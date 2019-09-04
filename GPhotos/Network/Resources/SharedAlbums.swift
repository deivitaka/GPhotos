//
//  SharedAlbums.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import Moya

public class SharedAlbums : GPhotosResource {
    
    fileprivate let api = MoyaProvider<SharedAlbumsService>(plugins: GPhotosApi.plugins)
    
    // MARK: List
    private struct List {
        var request = AlbumsList.Request()
        var page = 0
    }
    private var currentList = List()
    
}

// MARK:- List
public extension SharedAlbums {
    
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
                    guard let dict = self.handle(response: res),
                        let listRes = SharedAlbumsList.Response(JSON: dict) else {
                        completion([])
                        return
                    }
                    
                    self.currentList.request.pageToken = listRes.nextPageToken
                    self.currentList.page += 1
                    completion(listRes.sharedAlbums)
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
public extension SharedAlbums {
    
    func get(token: String, completion: @escaping ((Album?)->())) {
        autoAuthorize(scopes.share) {
            self.api.request(.get(token: token)) { (result) in
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

// MARK:- Join / Leave
public extension SharedAlbums {
    
    func join(token: String, completion: @escaping ((Album?)->())) {
        autoAuthorize(scopes.share) {
            self.api.request(.join(token: token)) { (result) in
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
    
    func leave(token: String, completion: @escaping ((Album?)->())) {
        autoAuthorize(scopes.share) {
            self.api.request(.leave(token: token)) { (result) in
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

