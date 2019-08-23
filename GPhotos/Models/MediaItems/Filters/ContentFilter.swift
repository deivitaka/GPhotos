//
//  ContentFilter.swift
//  GPhotos
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class ContentFilter : BaseMappable {
    public var includedContentCategories = [ContentCategory]()
    public var excludedContentCategories = [ContentCategory]()
    
    public override func mapping(map: Map) {
        includedContentCategories <- map["includedContentCategories"]
        excludedContentCategories <- map["excludedContentCategories"]
    }
    
    public enum ContentCategory: String, CaseIterable {
        /// Default content category. This category is ignored when any other category is used in the filter.
        case none = "NONE"
        /// Media items containing landscapes.
        case landscapes = "LANDSCAPES"
        /// Media items containing receipts.
        case receipts = "RECEIPTS"
        /// Media items containing cityscapes.
        case cityscapes = "CITYSCAPES"
        /// Media items containing landmarks.
        case landmarks = "LANDMARKS"
        /// Media items that are selfies.
        case selfies = "SELFIES"
        /// Media items containing people.
        case people = "PEOPLE"
        /// Media items containing pets.
        case pets = "PETS"
        /// Media items from weddings.
        case weddings = "WEDDINGS"
        /// Media items from birthdays.
        case birthdays = "BIRTHDAYS"
        /// Media items containing documents.
        case documents = "DOCUMENTS"
        /// Media items taken during travel.
        case travel = "TRAVEL"
        /// Media items containing animals.
        case animals = "ANIMALS"
        /// Media items containing food.
        case food = "FOOD"
        /// Media items from sporting events.
        case sport = "SPORT"
        /// Media items taken at night.
        case night = "NIGHT"
        /// Media items from performances.
        case performances = "PERFORMANCES"
        /// Media items containing whiteboards.
        case whiteboards = "WHITEBOARDS"
        /// Media items that are screenshots.
        case screenshots = "SCREENSHOTS"
        /// Media items that are considered to be utility. These include, but aren't limited to documents, screenshots, whiteboards etc.
        case utility = "UTILITY"
        /// Media items containing art.
        case arts = "ARTS"
        /// Media items containing crafts.
        case crafts = "CRAFTS"
        /// Media items related to fashion.
        case fashion = "FASHION"
        /// Media items containing houses.
        case houses = "HOUSES"
        /// Media items containing gardens.
        case gardens = "GARDENS"
        /// Media items containing flowers.
        case flowers = "FLOWERS"
        /// Media items taken of holidays.
        case holidays = "HOLIDAYS"
    }
}
