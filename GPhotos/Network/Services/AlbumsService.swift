//
//  AlbumsService.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import Moya
import ObjectMapper

internal enum AlbumsService {
    case list(req: AlbumsList.Request)
    case get(id: String)
    case share(req: AlbumsShare.Request)
    case unshare(id: String)
    case addEnrichment(req: AlbumsAddEnrichment.Request)
    case addMediaItems(req: AlbumsAddMediaItems.Request)
    case removeMediaItems(req: AlbumsAddMediaItems.Request)
    case create(album: Album)
}

extension AlbumsService : GPhotosService {
    var path: String {
        switch self {
        case .list:
            return "/albums"
        case .get(let id):
            return "/albums/\(id)"
        case .share(let req):
            return "/albums/\(req.id):share"
        case .unshare(let id):
            return "/albums/\(id):unshare"
        case .addEnrichment(let req):
            return "/albums/\(req.id):addEnrichment"
        case .addMediaItems(let req):
            return "/albums/\(req.id):batchAddMediaItems"
        case .removeMediaItems(let req):
            return "/albums/\(req.id):batchRemoveMediaItems"
        case .create:
            return "/albums"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list,
             .get:
            return .get
        case .share,
             .unshare,
             .addEnrichment,
             .addMediaItems,
             .removeMediaItems,
             .create:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .list(let req):
            return get(req)
        case .share(let req):
            return post(req)
        case .get,
             .unshare:
            return .requestPlain
        case .addEnrichment(let req):
            return post(req)
        case .addMediaItems(let req):
            return post(req)
        case .removeMediaItems(let req):
            return post(req)
        case .create(let album):
            return .requestParameters(parameters: ["album" : album.toJSON()], encoding: JSONEncoding.default)
        }
    }
}
