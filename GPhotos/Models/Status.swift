//
//  Status.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import ObjectMapper

public class Status : BaseMappable {
    public var code: Int?
    public var message: String?
    
    override public func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
