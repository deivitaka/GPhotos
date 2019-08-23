//
//  MediaMetadata.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import Foundation
import ObjectMapper

public class MediaMetadata: BaseMappable {
    
    public var creationTime: Date?
    public var height = 0
    public var width = 0
    public var photo: Photo?
    public var video: Video?
    
    // Mappable
    public override func mapping(map: Map) {
        creationTime <- (map["creationTime"], ISO8601DateTransform())
        height <- map["height"]
        width <- map["width"]
        photo <- map["photo"]
        video <- map["video"]
    }
    
}
