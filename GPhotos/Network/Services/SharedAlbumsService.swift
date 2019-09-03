//
//  SharedAlbumsService.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import Moya
import ObjectMapper

internal enum SharedAlbumsService {
    case get(token: String)
    case join(token: String)
    case leave(token: String)
    case list(req: AlbumsList.Request)
}

extension SharedAlbumsService : GPhotosService {
    var path: String {
        switch self {
        case .get(let token):
            return "/sharedAlbums/\(token)"
        case .join:
            return "/sharedAlbums:join"
        case .leave:
            return "/sharedAlbums:leave"
        case .list:
            return "/sharedAlbums"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get,
             .list:
            return .get
        case .join,
             .leave:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .list(let req):
            return get(req)
        case .get:
            return .requestPlain
        case .join(let req),
             .leave(let req):
            return .requestParameters(parameters: ["shareToken":req], encoding: JSONEncoding.default)
        }
    }
    
}
