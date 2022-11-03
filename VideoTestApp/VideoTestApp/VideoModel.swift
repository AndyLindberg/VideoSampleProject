//
//  VideoModel.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/21/22.
//

import Foundation

struct VideoModel: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnailURL: String?
    let videoURL: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
    }
}

struct Videos: Decodable {
    var videos: [VideoModel]
}
