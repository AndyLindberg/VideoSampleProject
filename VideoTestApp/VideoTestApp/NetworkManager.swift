//
//  NetworkManager.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/21/22.
//

import Foundation

class NetworkManager: DataSourceProtocol {
    func fetchVideos(completion: @escaping (Result<Videos, Error>) -> ()) {
        let urlString = StringConstants.videoURL
        fetchData(urlString: urlString, completion: completion)
    }
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else {
                return
            }

            do {
                let decoded: T = try data.decoded()
                
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    print("error")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
