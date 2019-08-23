//
//  BaseMappable.swift
//  GPhotos
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class BaseMappable: Mappable {
    public init() {}
    
    required public init(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {}
}
