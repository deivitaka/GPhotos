//
//  AlbumsAddMediaItems.swift
//  GPhotos
//
//  Created by Deivi Taka on 02.09.19.
//

import Foundation
import ObjectMapper

internal class AlbumsAddMediaItems {
    internal init() {}
    
    internal class Request : BaseMappable {
        var id: String = ""
        var mediaItemIds = [String]()
        
        override func mapping(map: Map) {
            mediaItemIds <- map["mediaItemIds"]
        }
    }
    
}
