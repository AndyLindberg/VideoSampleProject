//
//  VideoViewModel.swift
//  VideoStreamingApp
//
//  Created by Andy Lindberg on 11/10/22.
//

import Foundation

class VideoViewModel: ViewModelProtocol {
    
    
    internal let dataSource: DataSourceProtocol
    var video: VideoModel?
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchVideos(completion: @escaping() ->()) {
        dataSource.fetchVideos { [weak self] result in
            switch result {
            case .failure(_):
                print("Error")
            case.success(let response):
                self?.video = response.resource
                completion()
            }
        }
    }
}

protocol ViewModelProtocol {
    var dataSource: DataSourceProtocol { get }
    func fetchVideos(completion: @escaping() -> ())
    //func getFirstVideo() -> VideoModel?
    var video: VideoModel? { get set }
}
