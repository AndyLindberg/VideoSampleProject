//
//  ViewModelProtocol.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import Foundation

protocol ViewModelProtocol {
    var videos: [VideoModel] { get set }
    func fetchVideos(completion: @escaping() -> ())
    func getFirstVideo() -> VideoModel?
}
