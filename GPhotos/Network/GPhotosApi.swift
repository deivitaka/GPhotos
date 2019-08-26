//
//  GPhotosApi.swift
//  Alamofire
//
//  Created by Deivi Taka on 19.08.19.
//

import Foundation
import Moya

internal struct GPhotosApi {
    private init() {}
    
    fileprivate static let plugins: [PluginType] = [
        NetworkLoggerPlugin(verbose: config.printLogs),
        AccessTokenPlugin(tokenClosure: { return Strings.photosAccessToken })
    ]
    
    static let mediaItems = MoyaProvider<MediaItemsService>(plugins: GPhotosApi.plugins)
    static let albums = MoyaProvider<AlbumsService>(plugins: GPhotosApi.plugins)
    
    static func handle(response: Response) -> [String:Any]? {
        do {
            let response = try response.filterSuccessfulStatusCodes()
            return try response.mapJSON() as? [String:Any]
        }
        catch {
            log.e(error.localizedDescription)
            log.e("Could not parse response")
        }
        return nil
    }
    
    static func handle(error: MoyaError) {
        log.e(error.localizedDescription)
        log.e("Could not parse response")
    }
}
