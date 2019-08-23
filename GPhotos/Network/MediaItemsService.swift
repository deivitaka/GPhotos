//
//  MediaItemsService.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

internal enum MediaItemsService {
    case list(req: MediaItemsList.Request)
    case get(id: String)
    case batchGet
    case search(req: MediaItemsSearch.Request)
}

extension MediaItemsService : GPhotosService {
    var path: String {
        switch self {
        case .list:
            return "/mediaItems"
        case .get(let id):
            return "/mediaItems/\(id)"
        case .batchGet:
            return "/mediaItems:batchGet"
        case .search:
            return "/mediaItems:search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list,
             .get,
             .batchGet:
            return .get
        case .search:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .list(let req):
            return get(req)
        case .get,
             .batchGet:
            return .requestPlain
        case .search(let req):
            return post(req)
        }
    }
    
    private func get(_ req: Mappable) -> Task {
        return .requestParameters(parameters: req.toJSON(), encoding: URLEncoding.default)
    }
    
    private func post(_ req: Mappable) -> Task {
        return .requestCompositeParameters(bodyParameters: req.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
    }
}
