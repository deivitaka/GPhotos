//
//  MediaTypeFilter.swift
//  GPhotos
//
//  Created by Deivi Taka on 22.08.19.
//

import Foundation
import ObjectMapper

public class MediaTypeFilter : BaseMappable {
    public var mediaTypes = [MediaType]()
    
    public override func mapping(map: Map) {
        mediaTypes <- map["mediaTypes"]
    }
    
    public enum MediaType: String, CaseIterable {
        /// Treated as if no filters are applied. All media types are included.
        case allMedia = "ALL_MEDIA"
        /// All media items that are considered videos. This also includes movies the user has created using the Google Photos app.
        case video = "VIDEO"
        /// All media items that are considered photos. This includes .bmp, .gif, .ico, .jpg (and other spellings), .tiff, .webp and special photo types such as iOS live photos, Android motion photos, panoramas, photospheres.
        case photo = "PHOTO"
    }
}
