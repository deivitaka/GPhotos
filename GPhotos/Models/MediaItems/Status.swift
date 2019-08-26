//
//  Status.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import ObjectMapper

internal class Status : BaseMappable {
    var code: Int?
    var message: String?
    
    override func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
