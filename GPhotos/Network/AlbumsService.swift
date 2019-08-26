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
}

extension AlbumsService : GPhotosService {
    var path: String {
        switch self {
        case .list:
            return "/albums"
        case .get(let id):
            return "/albums/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list,
             .get:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .list(let req):
            return get(req)
        case .get:
            return .requestPlain
        }
    }
    
    private func get(_ req: Mappable) -> Task {
        return .requestParameters(parameters: req.toJSON(), encoding: URLEncoding.default)
    }
    
    private func post(_ req: Mappable) -> Task {
        return .requestCompositeParameters(bodyParameters: req.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
    }
}
