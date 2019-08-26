//
//  AlbumsList.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import ObjectMapper

internal class AlbumsList {
    internal init() {}
    
    internal class Request : BaseMappable {
        var pageSize: Int?
        var pageToken: String?
        var excludeNonAppCreatedData: Bool?
        
        override func mapping(map: Map) {
            pageSize <- map["pageSize"]
            pageToken <- map["pageToken"]
            excludeNonAppCreatedData <- map["excludeNonAppCreatedData"]
        }
    }
    
    internal class Response : BaseMappable {
        var nextPageToken: String?
        var albums = [Album]()
        
        override func mapping(map: Map) {
            nextPageToken <- map["nextPageToken"]
            albums <- map["albums"]
        }
    }
    
}
