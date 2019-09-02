//
//  AlbumsShare.swift
//  GPhotos
//
//  Created by Deivi Taka on 01.09.19.
//

import Foundation
import ObjectMapper

internal class AlbumsShare {
    internal init() {}
    
    internal class Request : BaseMappable {
        var id: String = ""
        var sharedAlbumOptions: SharedAlbumOptions?
        
        override func mapping(map: Map) {
            sharedAlbumOptions <- map["sharedAlbumOptions"]
        }
    }
    
    internal class Response : BaseMappable {
        var shareInfo: ShareInfo?
        
        override func mapping(map: Map) {
            shareInfo <- map["shareInfo"]
        }
    }
    
}
