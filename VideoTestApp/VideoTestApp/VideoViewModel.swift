//
//  VideoViewModel.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/21/22.
//

import Foundation

class VideoViewModel: ViewModelProtocol {
    private let dataSource: DataSourceProtocol
    var videos = [VideoModel]()
    
    init(dataSource: DataSourceProtocol = NetworkManager()) {
        self.dataSource = dataSource
    }
    
    func fetchVideos(completion: @escaping () -> ()) {
        dataSource.fetchVideos { [weak self] result in
            guard let weakSelf = self else {return}
            switch result {
            case .failure(_):
                print("failure")
            case .success(let response):
                weakSelf.videos = response.videos
                completion()
            }
        }
    }
    
    func getFirstVideo() -> VideoModel? {
        return videos[1]
    }

}

protocol ViewModelProtocol: AnyObject {
    var videos: [VideoModel] { get set }
    
    func fetchVideos(completion: @escaping () -> ())
    func getFirstVideo() -> VideoModel?
}
