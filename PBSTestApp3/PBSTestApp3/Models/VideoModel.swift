//
//  VideoModel.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import Foundation

struct VideoModel: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let videoURL: String?
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
    }
}

struct Videos: Decodable {
    var videos: [VideoModel]
}
