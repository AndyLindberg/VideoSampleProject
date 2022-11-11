//
//  VideoModel.swift
//  VideoStreamingApp
//
//  Created by Andy Lindberg on 11/10/22.
//

import Foundation

struct Resource: Decodable {
    let resource: VideoModel?
}
struct VideoModel: Decodable {
    let description: String?
    let videosArray: [Videos]
    
    enum CodingKeys: String, CodingKey {
        case description = "description_long"
        case videosArray = "hls_videos"
    }
}

struct Videos: Decodable {
    let url: String?
}

