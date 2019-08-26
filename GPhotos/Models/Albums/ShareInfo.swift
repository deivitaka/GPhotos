//
//  ShareInfo.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import ObjectMapper

public class ShareInfo: BaseMappable {
    public var shareToken = ""
    public var isJoined: Bool?
    public var isOwned: Bool?
    public var shareableUrl: URL?
    public var sharedAlbumOptions: SharedAlbumOptions?
    
    public override func mapping(map: Map) {
        shareableUrl <- (map["shareableUrl"], URLTransform())
        sharedAlbumOptions <- map["sharedAlbumOptions"]
        
        shareToken <- map["shareToken"]
        isJoined <- map["isJoined"]
        isOwned <- map["isOwned"]
    }
}
