//
//  MediaItems.swift
//  Alamofire
//
//  Created by Deivi Taka on 21.08.19.
//

import Foundation
import Moya

public class MediaItems : GPhotosResource {
    
    public struct Item {
        let image: UIImage?
        let data: Data?
        let url: URL?
        let filename: String?
        let mimeType: MimeType?
        
        public init(image: UIImage, filename: String? = nil, mimeType: MimeType? = nil) {
            self.image = image
            data = nil
            url = nil
            self.filename = filename
            self.mimeType = mimeType
        }
        
        public init(data: Data, filename: String?, mimeType: MimeType? = nil) {
            image = nil
            self.data = data
            url = nil
            self.filename = filename
            self.mimeType = mimeType
        }
        
        public init(url: URL, filename: String? = nil, mimeType: MimeType? = nil) {
            image = nil
            data = nil
            self.url = url
            self.filename = filename
            self.mimeType = mimeType
        }
    }
    
    fileprivate let api = MoyaProvider<MediaItemsService>(plugins: GPhotosApi.plugins)
    
    // MARK: List
    private struct List {
        var request = MediaItemsList.Request()
        var page = 0
    }
    private var currentList = List()
    
    // MARK: Search
    private struct Search {
        var request = MediaItemsSearch.Request()
        var page = 0
    }
    private var currentSearch = Search()

}

// MARK:- List
public extension MediaItems {
    
    func list(completion: @escaping (([MediaItem])->())) {
        if currentList.page > 0 && currentList.request.pageToken == nil {
            log.d("Reached end of mediaItems")
            completion([])
            return
        }
        
        autoAuthorize(scopes.read) {
            self.api.request(.list(req: self.currentList.request)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion([])
                        return
                    }
                    let listRes = MediaItemsList.Response(JSON: dict)
                    self.currentList.request.pageToken = listRes?.nextPageToken
                    self.currentList.page += 1
                    completion(listRes?.mediaItems ?? [])
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion([])
                }
            }
        }
    }
    
    func reloadList(completion: @escaping (([MediaItem])->())) {
        currentList = List()
        list(completion: completion)
    }
    
}

// MARK:- Search
public extension MediaItems {
    
    func search(with request: MediaItemsSearch.Request, completion: @escaping (([MediaItem])->())) {
        currentSearch.request.albumId = request.albumId
        currentSearch.request.filters = request.filters
        currentSearch.request.pageSize = request.pageSize
        
        if currentSearch.page > 0 && currentSearch.request.pageToken == nil {
            log.d("Reached end of mediaItems")
            completion([])
            return
        }
        
        autoAuthorize(scopes.read) {
            self.api.request(.search(req: self.currentSearch.request)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion([])
                        return
                    }
                    let searchRes = MediaItemsList.Response(JSON: dict)
                    self.currentSearch.request.pageToken = searchRes?.nextPageToken
                    self.currentSearch.page += 1
                    completion(searchRes?.mediaItems ?? [])
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion([])
                }
            }
        }
    }
    
    func reloadSearch(with request: MediaItemsSearch.Request, completion: @escaping (([MediaItem])->())) {
        currentSearch = Search()
        search(with: request, completion: completion)
    }
    
}

// MARK:- Get
public extension MediaItems {
    
    func get(id: String, completion: @escaping ((MediaItem?)->())) {
        autoAuthorize(scopes.read) {
            self.api.request(.get(id: id)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion(nil)
                        return
                    }
                    let item = MediaItem(JSON: dict)
                    completion(item)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    func getBatch(ids: [String], completion: @escaping (([MediaItem])->())) {
        autoAuthorize(scopes.read) {
            let req = MediaItemsBatchGet.Request()
            req.mediaItemIds = ids
            self.api.request(.batchGet(req: req)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion([])
                        return
                    }
                    let res = MediaItemsBatchGet.Response(JSON: dict)
                    let items = res?.mediaItemResults.compactMap({ $0.mediaItem })
                    completion(items ?? [])
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion([])
                }
            }
        }
    }
    
}

// MARK:- Batch create
public extension MediaItems {
    
    internal func upload(item: Item, completion: @escaping ((String?)->())) {
        var data = item.image?.pngData() ?? item.data
        if data == nil,
           let url = item.url {
            data = try? Data(contentsOf: url)
        }
        if data == nil {
            completion(nil)
            return
        }
        let filename = item.filename ?? item.url?.lastPathComponent
        let mime = item.mimeType ?? mimeType(ext: item.url?.pathExtension)
        upload(data: data!, filename: filename, mimeType: mime, completion: completion)
    }
    
    internal func upload(data: Data, filename: String?, mimeType: MimeType?, completion: @escaping ((String?)->())) {
        autoAuthorize(scopes.append) {
            self.api.request(.upload(image: data, filename: filename, mimeType: mimeType?.rawValue)) { (result) in
                switch result {
                case let .success(res):
                    guard let res = try? res.filterSuccessfulStatusCodes(),
                        let token = try? res.mapString() else {
                            completion(nil)
                            return
                    }
                    completion(token)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    internal func createBatch(with request: MediaItemsBatchCreate.Request, completion: @escaping (([MediaItemsBatchCreate.NewMediaItemResult])->())) {
        autoAuthorize(scopes.appendShare) {
            self.api.request(.batchCreate(req: request)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion([])
                        return
                    }
                    let response = MediaItemsBatchCreate.Response(JSON: dict)
                    completion(response?.newMediaItemResults ?? [])
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion([])
                }
            }
        }
    }
    
    func upload(items: [Item], completion: @escaping (([MediaItemsBatchCreate.NewMediaItemResult])->())) {
        var items = items
        var tokens = [String]()
        
        func addItems() {
            let req = MediaItemsBatchCreate.Request()
            req.newMediaItems = tokens.map({
                let simpleItem = MediaItemsBatchCreate.SimpleMediaItem()
                simpleItem.uploadToken = $0
                
                let item = MediaItemsBatchCreate.NewMediaItem()
                item.description = ""
                item.simpleMediaItem = simpleItem
                
                return item
            })
            createBatch(with: req, completion: completion)
        }
        
        func upload() {
            if items.isEmpty {
                addItems()
                return
            }
            self.upload(item: items.popLast()!) { (token) in
                if let token = token { tokens.append(token) }
                upload()
            }
        }
        
        upload()
    }
    
}
