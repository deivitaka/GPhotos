//
//  Photo.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import Foundation
import ObjectMapper

public class Photo: BaseMappable {
    
    public var cameraMake = ""
    public var cameraModel = ""
    public var focalLength = 0
    public var apertureFNumber = 0
    public var isoEquivalent = 0
    public var exposureTime = ""
    
    public override func mapping(map: Map) {
        cameraMake <- map["cameraMake"]
        cameraModel <- map["cameraModel"]
        focalLength <- map["focalLength"]
        apertureFNumber <- map["apertureFNumber"]
        isoEquivalent <- map["isoEquivalent"]
        exposureTime <- map["exposureTime"]
    }
}
