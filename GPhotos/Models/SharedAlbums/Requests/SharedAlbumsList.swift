//
//  SharedAlbumsList.swift
//  GPhotos
//
//  Created by Deivi Taka on 29.08.19.
//

import Foundation
import ObjectMapper

internal class SharedAlbumsList {
    internal init() {}
    
    internal class Response : BaseMappable {
        var nextPageToken: String?
        var sharedAlbums = [Album]()
        
        override func mapping(map: Map) {
            nextPageToken <- map["nextPageToken"]
            sharedAlbums <- map["sharedAlbums"]
        }
    }
    
}
