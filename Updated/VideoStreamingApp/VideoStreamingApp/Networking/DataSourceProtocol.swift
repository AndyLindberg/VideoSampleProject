//
//  DataSourceProtocol.swift
//  VideoStreamingApp
//
//  Created by Andy Lindberg on 11/10/22.
//

import Foundation

protocol DataSourceProtocol {
    func fetchVideos(completion: @escaping(Result<Resource, Error>) -> ())
}
