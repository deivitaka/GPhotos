//
//  MediaItemsSearch.swift
//  Alamofire
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class MediaItemsSearch {
    internal init() {}
    
    public class Request : BaseMappable {
        public var albumId: String?
        internal var pageSize: Int?
        internal var pageToken: String?
        public var filters: Filters?
        
        public init(albumId: String? = nil, filters: Filters? = nil) {
            super.init()
            self.albumId = albumId
            self.filters = filters
        }
        
        required public init(map: Map) {
            super.init(map: map)
        }
        
        override public func mapping(map: Map) {
            albumId <- map["albumId"]
            pageSize <- map["pageSize"]
            pageToken <- map["pageToken"]
            filters <- map["filters"]
        }
    }
    
}
