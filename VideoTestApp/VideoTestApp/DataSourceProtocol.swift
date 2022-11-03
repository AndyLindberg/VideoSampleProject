//
//  DataSourceProtocol.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/21/22.
//

import Foundation

protocol DataSourceProtocol: AnyObject {
    func fetchVideos(completion: @escaping (Result<Videos, Error>) -> ())
}
