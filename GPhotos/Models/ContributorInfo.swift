//
//  ContributorInfo.swift
//  Alamofire
//
//  Created by Deivi Taka on 21.08.19.
//

import Foundation
import ObjectMapper

public class ContributorInfo: BaseMappable {
    
    public var profilePictureBaseUrl: URL?
    public var displayName = ""
    
    public override func mapping(map: Map) {
        profilePictureBaseUrl <- (map["profilePictureBaseUrl"], URLTransform())
        displayName <- map["displayName"]
    }
    
}
