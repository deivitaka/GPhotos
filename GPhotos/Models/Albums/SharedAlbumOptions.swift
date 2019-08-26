//
//  SharedAlbumOptions.swift
//  GPhotos
//
//  Created by Deivi Taka on 26.08.19.
//

import Foundation
import ObjectMapper

public class SharedAlbumOptions: BaseMappable {
    public var isCollaborative: Bool?
    public var isCommentable: Bool?
    
    public override func mapping(map: Map) {
        isCollaborative <- map["isCollaborative"]
        isCommentable <- map["isCommentable"]
    }
}
