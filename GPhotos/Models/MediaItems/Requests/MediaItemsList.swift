//
//  MediaItemsList.swift
//  Alamofire
//
//  Created by Deivi Taka on 21.08.19.
//

import Foundation
import ObjectMapper

internal class MediaItemsList {
    internal init() {}
    
    internal class Request : BaseMappable {
        var pageSize: Int?
        var pageToken: String?
        
        override func mapping(map: Map) {
            pageSize <- map["pageSize"]
            pageToken <- map["pageToken"]
        }
    }
    
    internal class Response : BaseMappable {
        var nextPageToken: String?
        var mediaItems = [MediaItem]()
        
        override func mapping(map: Map) {
            nextPageToken <- map["nextPageToken"]
            mediaItems <- map["mediaItems"]
        }
    }

}
