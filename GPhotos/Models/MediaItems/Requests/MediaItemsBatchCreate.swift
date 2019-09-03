//
//  MediaItemsBatchCreate.swift
//  GPhotos
//
//  Created by Deivi Taka on 03.09.19.
//

import Foundation
import ObjectMapper

public class MediaItemsBatchCreate {
    internal init() {}
    
    public class Request : BaseMappable {
        public var albumId = ""
        public var newMediaItems = [NewMediaItem]()
        public var albumPosition: AlbumPosition?
        
        override public func mapping(map: Map) {
            albumId <- map["albumId"]
            newMediaItems <- map["newMediaItems"]
            albumPosition <- map["albumPosition"]
        }
    }
    
    public class Response : BaseMappable {
        public var newMediaItemResults = [NewMediaItemResult]()
        
        override public func mapping(map: Map) {
            newMediaItemResults <- map["newMediaItemResults"]
        }
    }
    
    public class NewMediaItem : BaseMappable {
        public var description = ""
        public var simpleMediaItem: SimpleMediaItem?
        
        override public func mapping(map: Map) {
            description <- map["description"]
            simpleMediaItem <- map["simpleMediaItem"]
        }
    }
    
    public class SimpleMediaItem : BaseMappable {
        public var uploadToken = ""
        
        override public func mapping(map: Map) {
            uploadToken <- map["uploadToken"]
        }
    }
    
    public class NewMediaItemResult : BaseMappable {
        public var uploadToken = ""
        public var status: Status?
        public var mediaItem: MediaItem?
        
        override public func mapping(map: Map) {
            uploadToken <- map["uploadToken"]
            status <- map["status"]
            mediaItem <- map["mediaItem"]
        }
    }
    
}
