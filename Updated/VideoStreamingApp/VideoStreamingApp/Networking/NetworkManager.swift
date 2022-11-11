//
//  NetworkManager.swift
//  VideoStreamingApp
//
//  Created by Andy Lindberg on 11/10/22.
//

import Foundation

class NetworkManager: DataSourceProtocol {
    func fetchVideos(completion: @escaping (Result<Resource, Error>) -> ()) {
        fetchData(with: StringConstants.videoURL, completion: completion)
    }
    

    func fetchData<T: Decodable>(with urlString: String, completion: @escaping(Result<T, Error>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("4.1.8", forHTTPHeaderField: "X-PBS-PlatformVersion")
        request.setValue("Basic Y3Jpc3RpOnRlc3Q=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let jsonDecoded: T = try data.decoded()
                DispatchQueue.main.async {
                    completion(.success(jsonDecoded))
                }
            }catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}

extension Data {
    func decoded<T:Decodable>() throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}
