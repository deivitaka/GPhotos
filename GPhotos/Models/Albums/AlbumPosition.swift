//
//  AlbumPosition.swift
//  GPhotos
//
//  Created by Deivi Taka on 02.09.19.
//

import Foundation
import ObjectMapper

public class AlbumPosition: BaseMappable {
    public var position = PositionType.unspecified
    /// The item to which the position is relative to. This must be set only if using position type AFTER_MEDIA_ITEM or AFTER_ENRICHMENT_ITEM.
    /// Union field relative_item can be only one of the following
    public var relativeMediaItemId: String? { didSet {
        guard self.relativeMediaItemId != nil else { return }
        relativeEnrichmentItemId = nil
    }}
    public var relativeEnrichmentItemId: String? { didSet {
        guard self.relativeEnrichmentItemId != nil else { return }
        relativeMediaItemId = nil
    }}
    
    public override func mapping(map: Map) {
        position <- map["position"]
        relativeMediaItemId <- map["relativeMediaItemId"]
        relativeEnrichmentItemId <- map["relativeEnrichmentItemId"]
    }
    
    public enum PositionType: String, CaseIterable {
        /// Default value if this enum isn't set.
        case unspecified = "POSITION_TYPE_UNSPECIFIED"
        /// At the beginning of the album.
        case firstInAlbum = "FIRST_IN_ALBUM"
        /// At the end of the album.
        case lastInAlbum = "LAST_IN_ALBUM"
        /// After a media item.
        case afterMediaItem = "AFTER_MEDIA_ITEM"
        /// After an enrichment item.
        case afterEnrichmentItem = "AFTER_ENRICHMENT_ITEM"
    }
    
}
