//
//  Filters.swift
//  Alamofire
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class Filters : BaseMappable {
    public var dateFilter: DateFilter?
    public var contentFilter: ContentFilter?
    public var mediaTypeFilter: MediaTypeFilter?
    public var featureFilter: FeatureFilter?
    public var includeArchivedMedia: Bool?
    public var excludeNonAppCreatedData: Bool?
    
    public override func mapping(map: Map) {
        dateFilter <- map["dateFilter"]
        contentFilter <- map["contentFilter"]
        mediaTypeFilter <- map["mediaTypeFilter"]
        featureFilter <- map["featureFilter"]
        includeArchivedMedia <- map["includeArchivedMedia"]
        excludeNonAppCreatedData <- map["excludeNonAppCreatedData"]
    }
}
