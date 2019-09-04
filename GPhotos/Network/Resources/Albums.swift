//
//  Albums.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import Moya

public class Albums : GPhotosResource {
    
    fileprivate let api = MoyaProvider<AlbumsService>(plugins: GPhotosApi.plugins)
    
    // MARK: List
    private struct List {
        var request = AlbumsList.Request()
        var page = 0
    }
    private var currentList = List()
    
}

// MARK:- List
public extension Albums {
    
    func list(completion: @escaping (([Album])->())) {
        if currentList.page > 0 && currentList.request.pageToken == nil {
            log.d("Reached end of albums")
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
                    let listRes = AlbumsList.Response(JSON: dict)
                    self.currentList.request.pageToken = listRes?.nextPageToken
                    self.currentList.page += 1
                    completion(listRes?.albums ?? [])
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion([])
                }
            }
        }
    }
    
    func reloadList(completion: @escaping (([Album])->())) {
        currentList = List()
        list(completion: completion)
    }
    
}

// MARK:- Get
public extension Albums {

    func get(id: String, completion: @escaping ((Album?)->())) {
        autoAuthorize(scopes.read) {
            self.api.request(.get(id: id)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion(nil)
                        return
                    }
                    let item = Album(JSON: dict)
                    completion(item)

                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }

}

// MARK:- Sharing
public extension Albums {
    
    func share(id: String, options: SharedAlbumOptions? = nil, completion: @escaping ((ShareInfo?)->())) {
        autoAuthorize(scopes.share) {
            let req = AlbumsShare.Request()
            req.id = id
            req.sharedAlbumOptions = options
            self.api.request(.share(req: req)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion(nil)
                        return
                    }
                    let res = AlbumsShare.Response(JSON: dict)
                    completion(res?.shareInfo)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    func unshare(id: String, completion: @escaping ((Bool)->())) {
        autoAuthorize(scopes.share) {
            self.api.request(.unshare(id: id)) { (result) in
                switch result {
                case let .success(res):
                    guard let _ = self.handle(response: res),
                        let _ = try? res.filterSuccessfulStatusCodes() else {
                        completion(false)
                        return
                    }
                    completion(true)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(false)
                }
            }
        }
    }
    
}

// MARK:- Other
public extension Albums {
    
    func addEnrichment(id: String, enrichment: NewEnrichmentItem, position: AlbumPosition? = nil, options: SharedAlbumOptions? = nil, completion: @escaping ((String?)->())) {
        autoAuthorize(scopes.appendShare) {
            let req = AlbumsAddEnrichment.Request()
            req.id = id
            req.newEnrichmentItem = enrichment
            req.albumPosition = position
            self.api.request(.addEnrichment(req: req)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion(nil)
                        return
                    }
                    let res = AlbumsAddEnrichment.Response(JSON: dict)
                    completion(res?.enrichmentItem?.id)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    func addMediaItems(id: String, mediaIds: [String], completion: @escaping ((Bool)->())) {
        autoAuthorize(scopes.appendShare) {
            let req = AlbumsAddMediaItems.Request()
            req.id = id
            req.mediaItemIds = mediaIds
            self.api.request(.addMediaItems(req: req)) { (result) in
                switch result {
                case let .success(res):
                    guard let _ = self.handle(response: res),
                        let _ = try? res.filterSuccessfulStatusCodes() else {
                            completion(false)
                            return
                    }
                    completion(true)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(false)
                }
            }
        }
    }
    
    func removeMediaItems(id: String, mediaIds: [String], completion: @escaping ((Bool)->())) {
        autoAuthorize(scopes.readAppend) {
            let req = AlbumsAddMediaItems.Request()
            req.id = id
            req.mediaItemIds = mediaIds
            self.api.request(.removeMediaItems(req: req)) { (result) in
                switch result {
                case let .success(res):
                    guard let _ = self.handle(response: res),
                        let _ = try? res.filterSuccessfulStatusCodes() else {
                            completion(false)
                            return
                    }
                    completion(true)
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(false)
                }
            }
        }
    }
    
    func create(album: Album, completion: @escaping ((Album?)->())) {
        autoAuthorize(scopes.appendShare) {
            self.api.request(.create(album: album)) { (result) in
                switch result {
                case let .success(res):
                    guard let dict = self.handle(response: res) else {
                        completion(nil)
                        return
                    }
                    completion(Album(JSON: dict))
                    
                case let .failure(error):
                    self.handle(error: error)
                    completion(nil)
                }
            }
        }
    }
    
}
