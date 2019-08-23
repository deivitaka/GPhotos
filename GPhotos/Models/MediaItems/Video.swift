//
//  Video.swift
//  Alamofire
//
//  Created by Deivi Taka on 21.08.19.
//

import Foundation
import ObjectMapper

public class Video: BaseMappable {
    public var cameraMake = ""
    public var cameraModel = ""
    public var fps = 0
    public var status = VideoProcessingStatus.unspecified
    
    public override func mapping(map: Map) {
        cameraMake <- map["cameraMake"]
        cameraModel <- map["cameraModel"]
        fps <- map["fps"]
        status <- (map["status"], EnumTransform<VideoProcessingStatus>())
    }
}

public enum VideoProcessingStatus : String {
    /// Video processing status is unknown.
    case unspecified = "UNSPECIFIED"
    /// Video is being processed. The user sees an icon for this video in the Google Photos app; however, it isn't playable yet.
    case processing = "PROCESSING"
    /// Video processing is complete and it is now ready for viewing.
    case ready = "READY"
    /// Something has gone wrong and the video has failed to process.
    case failed = "FAILED"
}
