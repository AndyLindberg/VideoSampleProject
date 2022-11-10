//
//  VideoViewModel.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import Foundation

class VideoViewModel: ViewModelProtocol {
    private let dataSource: DataSourceProtocol
    var videos = [VideoModel]()
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchVideos(completion: @escaping() -> ()) {
        dataSource.fetchVideos { [weak self] result in
            switch result {
            case .failure(_):
                print("Error")
            case .success(let response):
                self?.videos = response.videos
                completion()
            }
        }
    }
    
    func getFirstVideo() -> VideoModel? {
        videos[0]
    }
}
