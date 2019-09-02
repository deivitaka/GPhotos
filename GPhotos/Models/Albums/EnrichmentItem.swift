//
//  EnrichmentItem.swift
//  GPhotos
//
//  Created by Deivi Taka on 02.09.19.
//

import Foundation
import ObjectMapper

public class EnrichmentItem : BaseMappable {
    var id = ""
    
    public override func mapping(map: Map) {
        id <- map["id"]
    }
}
