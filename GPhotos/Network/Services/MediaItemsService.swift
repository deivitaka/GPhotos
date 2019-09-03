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
    case batchGet(req: MediaItemsBatchGet.Request)
    case search(req: MediaItemsSearch.Request)
    case batchCreate(req: MediaItemsBatchCreate.Request)
    case upload(image: Data, filename: String?)
}

extension MediaItemsService : GPhotosService {
    var headers: [String: String]? {
        switch self {
        case .upload(_, let filename):
            return [
                "Content-type": "application/octet-stream",
                "X-Goog-Upload-Protocol": "raw",
                "X-Goog-Upload-File-Name": filename ?? "",
                "Accept-Encoding": "gzip"
            ]
        default:
            return [
                "Content-type": "application/json",
                "Accept-Encoding": "gzip"
            ]
        }
    }
    
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
        case .batchCreate:
            return "/mediaItems:batchCreate"
        case .upload:
            return "/uploads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list,
             .get,
             .batchGet:
            return .get
        case .search,
             .batchCreate,
             .upload:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .list(let req):
            return get(req)
        case .batchGet(let req):
            let encoding = URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            return .requestParameters(parameters: ["mediaItemIds":req.mediaItemIds],
                                      encoding: encoding)
        case .get:
            return .requestPlain
        case .search(let req):
            return post(req)
        case .batchCreate(let req):
            return post(req)
        case .upload(let image, _):
            return .requestData(image)
        }
    }

}
