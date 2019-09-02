//
//  NewEnrichmentItem.swift
//  GPhotos
//
//  Created by Deivi Taka on 02.09.19.
//

import Foundation
import ObjectMapper

public class NewEnrichmentItem: BaseMappable {
    /// enrichment can be only one of the following
    public var textEnrichment: TextEnrichment? { didSet {
        guard self.textEnrichment != nil else { return }
        locationEnrichment = nil
        mapEnrichment = nil
    }}
    public var locationEnrichment: LocationEnrichment? { didSet {
        guard self.locationEnrichment != nil else { return }
        textEnrichment = nil
        mapEnrichment = nil
    }}
    public var mapEnrichment: MapEnrichment? { didSet {
        guard self.mapEnrichment != nil else { return }
        locationEnrichment = nil
        textEnrichment = nil
    }}
    
    public override func mapping(map: Map) {
        textEnrichment <- map["textEnrichment"]
        locationEnrichment <- map["locationEnrichment"]
        mapEnrichment <- map["mapEnrichment"]
    }
    
}

public class TextEnrichment : BaseMappable {
    
    var text = ""
    
    public override func mapping(map: Map) {
        text <- map["text"]
    }
    
}

public class LocationEnrichment : BaseMappable {
    
    var location: Location?
    
    public override func mapping(map: Map) {
        location <- map["location"]
    }
    
}

public class MapEnrichment : BaseMappable {
    
    var origin: Location?
    var destination: Location?
    
    public override func mapping(map: Map) {
        origin <- map["origin"]
        destination <- map["destination"]
    }
    
}

public class Location : BaseMappable {
    var locationName = ""
    var latlng: LatLng?
    
    public override func mapping(map: Map) {
        locationName <- map["locationName"]
        latlng <- map["latlng"]
    }
    
    public class LatLng : BaseMappable {
        var latitude: Double?
        var longitude: Double?
        
        public override func mapping(map: Map) {
            latitude <- map["latitude"]
            longitude <- map["longitude"]
        }
    }
}
