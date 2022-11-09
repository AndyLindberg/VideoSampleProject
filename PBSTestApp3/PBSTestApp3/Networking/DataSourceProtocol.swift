//
//  DataSourceProtocol.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import Foundation

protocol DataSourceProtocol {
    func fetchVideos(completion: @escaping(Result<Videos, Error>) -> ())
}
