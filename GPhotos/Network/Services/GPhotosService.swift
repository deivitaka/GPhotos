//
//  GPhotosService.swift
//  Alamofire
//
//  Created by Deivi Taka on 21.08.19.
//

import Foundation
import Moya

protocol GPhotosService : AccessTokenAuthorizable, TargetType {}

extension GPhotosService {
    var authorizationType: AuthorizationType { return .bearer }
    var baseURL: URL { return URL(string: "https://photoslibrary.googleapis.com/v1")! }
    var sampleData: Data { return Data() }
    var headers: [String: String]? { return [
        "Content-type": "application/json",
        "Accept-Encoding": "gzip"
        ] }
}
