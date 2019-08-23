//
//  DateFilter.swift
//  GPhotos
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class DateFilter : BaseMappable {
    public var dates = [Date]()
    public var ranges = [DateRange]()
    
    public init(with dates: [Date]) {
        super.init()
        self.dates = dates
    }
    
    public init(with ranges: [DateRange]) {
        super.init()
        self.ranges = ranges
    }
    
    required public init(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        dates <- map["dates"]
        ranges <- map["ranges"]
    }
    
    public class Date : BaseMappable {
        public var year: Int?
        public var month: Int?
        public var day: Int?
        
        public init(from date: Foundation.Date) {
            super.init()
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            year = components.year
            month = components.month
            day = components.day
        }
        
        required public init(map: Map) {
            super.init(map: map)
        }
        
        override public func mapping(map: Map) {
            year <- map["year"]
            month <- map["month"]
            day <- map["day"]
        }
    }
    
    public class DateRange : BaseMappable {
        public var startDate: Date?
        public var endDate: Date?
        
        override public func mapping(map: Map) {
            startDate <- map["startDate"]
            endDate <- map["endDate"]
        }
    }
}
