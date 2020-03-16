//
//  ViewController.swift
//  GPhotos
//
//  Created by Deivi Taka on 08/20/2019.
//  Copyright (c) 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GPhotos
import Photos

class ViewController: UIViewController {
    
    var loginB: UIButton!
    var stackView: UIStackView!
    
    fileprivate var items = [MediaItem]()
    fileprivate var albumList = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func loginButtonClicked() {
        loginB.isEnabled = false
        if GPhotos.isAuthorized {
            GPhotos.logout()
            self.loginB.isEnabled = true
            self.updateLoginButton()
            self.stackView.isHidden = true
        } else {
            GPhotos.authorize() { (success, error) in
                if let error = error { print (error.localizedDescription) }
                else { self.stackView.isHidden = false }
                self.updateLoginButton()
                self.loginB.isEnabled = true
            }
        }
    }

}

// Media Items
extension ViewController {
    
    @objc func listItems() {
        GPhotosApi.mediaItems.list { items in
            print (items.map({ $0.id }).sorted())
            self.items = items
        }
    }
    
    @objc func reloadList() {
        GPhotosApi.mediaItems.reloadList { items in
            print (items.map({ $0.id }).sorted())
            self.items = items
        }
    }
    
    @objc func searchItems() {
        // Search photos made today
        let filter = Filters()
        filter.dateFilter = DateFilter(with: [
            DateFilter.Date(from: Date())
            ])
        let request = MediaItemsSearch.Request(filters: filter)
        GPhotosApi.mediaItems.search(with: request) { items in
            print (items.map({ $0.id }).sorted())
            self.items = items
        }
    }
    
    @objc func reloadSearch() {
        // Search photos made today
        let filter = Filters()
        filter.dateFilter = DateFilter(with: [
            DateFilter.Date(from: Date())
            ])
        let request = MediaItemsSearch.Request(filters: filter)
        GPhotosApi.mediaItems.reloadSearch(with: request) { items in
            print (items.map({ $0.id }).sorted())
            self.items = items
        }
    }
    
    @objc func getMediaItem() {
        guard let last = self.items.last else {
            print ("List or search first")
            return
        }
        
        GPhotosApi.mediaItems.get(id: last.id, completion: { (item) in
            print (item?.id)
        })
    }
    
    @objc func getBatchMediaItems() {
        guard self.items.count >= 3 else {
            print ("List or search first")
            return
        }
        
        let ids = self.items.suffix(3).map({ $0.id })
        GPhotosApi.mediaItems.getBatch(ids: ids, completion: { (items) in
            print (items.map({ $0.id }).sorted())
        })
    }
    
    @objc func uploadMediaItem() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
}

// Albums
extension ViewController {
    
    @objc func listAlbums() {
        GPhotosApi.albums.list { items in
            print (items.toJSONString(prettyPrint: true))
            self.albumList = items
        }
    }
    
    @objc func reloadAlbumsList() {
        GPhotosApi.albums.reloadList { items in
            print (items.map({ $0.id }).sorted())
            self.albumList = items
        }
    }
    
    @objc func createAlbum() {
        guard let last = self.items.last else {
            print ("List or search first")
            return
        }
        
        let album = Album()
        album.title = "Test album"
        album.mediaItemsCount = "1"
        GPhotosApi.albums.create(album: album, completion: { (item) in
            if let item = item {
                print (item.id)
                self.albumList = [item]
            }
        })
    }
    
    @objc func getAlbum() {
        guard let last = self.albumList.last else {
            print ("List first")
            return
        }

        GPhotosApi.albums.get(id: last.id, completion: { (item) in
            print (item?.id)
        })
    }
    
    @objc func shareAlbum() {
        guard let last = self.albumList.last else {
            print ("List first")
            return
        }
        
        let options = SharedAlbumOptions()
        options.isCollaborative = true
        options.isCommentable = true
        GPhotosApi.albums.share(id: last.id, options: options) { (info) in
            print (info?.shareableUrl)
        }
    }

}

// Shared Albums
extension ViewController {
    
    @objc func listSharedAlbums() {
        GPhotosApi.sharedAlbums.list { items in
            print (items.toJSONString(prettyPrint: true))
            self.albumList = items
        }
    }
    
    @objc func reloadSharedAlbumsList() {
        GPhotosApi.sharedAlbums.reloadList { items in
            print (items.map({ $0.id }).sorted())
            self.albumList = items
        }
    }
    
}

private extension ViewController {
    
    func setupView() {
        func setupLogin() {
            loginB = UIButton()
            loginB.translatesAutoresizingMaskIntoConstraints = false
            loginB.layer.cornerRadius = 10
            loginB.contentEdgeInsets = .init(top: 4, left: 10, bottom: 4, right: 10)
            loginB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
            view.addSubview(loginB)
            updateLoginButton()
            
            let loginConstrTop = NSLayoutConstraint(item: loginB!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 10)
            let loginConstrX = NSLayoutConstraint(item: loginB!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([ loginConstrTop, loginConstrX ])
        }
        
        func addItems() {
            addButton(title: "List media items", action: #selector(listItems))
            addButton(title: "Reload list", action: #selector(reloadList))
            addSeparator()
            addButton(title: "Search media item", action: #selector(searchItems))
            addButton(title: "Reload search", action: #selector(reloadSearch))
            addSeparator()
            addButton(title: "Get last item", action: #selector(getMediaItem))
            addButton(title: "Get last 3 items", action: #selector(getBatchMediaItems))
            addSeparator()
            addButton(title: "Upload media item", action: #selector(uploadMediaItem))
            addSeparator()
            addSeparator()
            addButton(title: "List albums", action: #selector(listAlbums))
            addButton(title: "Reload list", action: #selector(reloadAlbumsList))
            addSeparator()
            addButton(title: "Create album", action: #selector(createAlbum))
            addButton(title: "Get last album", action: #selector(getAlbum))
            addButton(title: "Share album", action: #selector(shareAlbum))
            addSeparator()
            addSeparator()
            addButton(title: "List shared albums", action: #selector(listSharedAlbums))
            addButton(title: "Reload list", action: #selector(reloadSharedAlbumsList))
        }
        
        func setupStackView() {
            stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.isHidden = !GPhotos.isAuthorized
            
            addItems()
            view.addSubview(stackView)
            
            let svConstrLeft = NSLayoutConstraint(item: stackView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 50)
            let svConstrRight = NSLayoutConstraint(item: stackView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50)
            let svConstrTop = NSLayoutConstraint(item: stackView!, attribute: .top, relatedBy: .lessThanOrEqual, toItem: loginB, attribute: .bottom, multiplier: 1, constant: 20)
            let svConstrBottom = NSLayoutConstraint(item: stackView!, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: -50)
            
            NSLayoutConstraint.activate([
                svConstrLeft, svConstrRight, svConstrTop, svConstrBottom,
            ])
        }
        
        setupLogin()
        setupStackView()
    }
    
    func addButton(title: String, action: Selector) {
        let b = UIButton()
        b.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        b.setTitle(title, for: .normal)
        b.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(b)
    }
    
    func addSeparator() {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stackView.addArrangedSubview(v)
        
        let vHeight = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        NSLayoutConstraint.activate([ vHeight ])
    }
    
    func updateLoginButton() {
        if GPhotos.isAuthorized {
            loginB.setTitle("Logout", for: .normal)
            loginB.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            loginB.setTitle("Login", for: .normal)
            loginB.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    
    func filename(for info: [UIImagePickerController.InfoKey : Any]) -> String? {
        var asset: PHAsset? = nil
        
        if #available(iOS 11.0, *) {
            asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
        } else if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil).firstObject
        }
        
        return asset == nil ? nil :
            PHAssetResource.assetResources(for: asset!).first?.originalFilename
    }
    
}

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let filename = self.filename(for: info)
            
            GPhotosApi.mediaItems.upload(images: [image], filenames: [filename], completion: { (res) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
}
