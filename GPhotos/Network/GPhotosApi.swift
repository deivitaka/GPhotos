//
//  GPhotosApi.swift
//  Alamofire
//
//  Created by Deivi Taka on 19.08.19.
//

import Foundation
import Moya

public struct GPhotosApi {
    private init() {}
    
    internal static let plugins: [PluginType] = [
        NetworkLoggerPlugin(verbose: config.printNetworkLogs),
        AccessTokenPlugin(tokenClosure: { return Strings.photosAccessToken })
    ]
    
    public static let mediaItems = MediaItems()
    public static let albums = Albums()
    public static let sharedAlbums = SharedAlbums()
}
