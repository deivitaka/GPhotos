//
//  ViewController.swift
//  GPhotos
//
//  Created by Deivi Taka on 08/20/2019.
//  Copyright (c) 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GPhotos

class ViewController: UIViewController {
    
    var loginB: UIButton!
    var stackView: UIStackView!
    
    fileprivate var mediaItems = MediaItems()
    fileprivate var items = [MediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// Actions
extension ViewController {
    
    @objc func loginButtonClicked() {
        loginB.isEnabled = false
        if GPhotos.isAuthorized {
            GPhotos.logout()
            self.loginB.isEnabled = true
            self.updateLoginButton()
        } else {
            GPhotos.authorize() { (success, error) in
                self.updateLoginButton()
                self.loginB.isEnabled = true
            }
        }
    }
    
    @objc func listItems() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            self.mediaItems.list { items in
                print (items.map({ $0.id }).sorted())
                self.items = items
            }
        }
    }
    
    @objc func reloadList() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            self.mediaItems.reloadList { items in
                print (items.map({ $0.id }).sorted())
                self.items = items
            }
        }
    }
    
    @objc func searchItems() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            // Search photos made today
            let filter = Filters()
            filter.dateFilter = DateFilter(with: [
                DateFilter.Date(from: Date())
                ])
            let request = MediaItemsSearch.Request(filters: filter)
            self.mediaItems.search(with: request) { items in
                print (items.map({ $0.id }).sorted())
                self.items = items
            }
        }
    }
    
    @objc func reloadSearch() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            // Search photos made today
            let filter = Filters()
            filter.dateFilter = DateFilter(with: [
                DateFilter.Date(from: Date())
                ])
            let request = MediaItemsSearch.Request(filters: filter)
            self.mediaItems.reloadSearch(with: request) { items in
                print (items.map({ $0.id }).sorted())
                self.items = items
            }
        }
    }
    
    @objc func getMediaItem() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            guard let last = self.items.last else {
                print ("List or search first")
                return
            }
            
            self.mediaItems.get(id: last.id, completion: { (item) in
                print (item?.id)
            })
        }
    }
    
    @objc func getBatchMediaItems() {
        GPhotos.authorize(with: [.readAndAppend]) { (success, error) in
            guard success else {
                print (error?.localizedDescription)
                return
            }
            
            guard self.items.count >= 3 else {
                print ("List or search first")
                return
            }
            
            let ids = self.items.suffix(3).map({ $0.id })
            self.mediaItems.getBatch(ids: ids, completion: { (items) in
                print (items.map({ $0.id }).sorted())
            })
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
            
            let loginConstrY = NSLayoutConstraint(item: loginB!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.6, constant: 0)
            let loginConstrX = NSLayoutConstraint(item: loginB!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([ loginConstrY, loginConstrX ])
        }
        
        func setupStackView() {
            stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            addButton(title: "List media items", action: #selector(listItems))
            addButton(title: "Reload list", action: #selector(reloadList))
            addSeparator()
            addButton(title: "Search media item", action: #selector(searchItems))
            addButton(title: "Reload search", action: #selector(reloadSearch))
            addSeparator()
            addButton(title: "Get last item", action: #selector(getMediaItem))
            addButton(title: "Get last 3 items", action: #selector(getBatchMediaItems))
            addSeparator()
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
        v.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
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
    
}
