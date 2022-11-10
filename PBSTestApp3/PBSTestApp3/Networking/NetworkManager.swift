//
//  NetworkManager.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import Foundation

class NetworkManager: DataSourceProtocol {
    func fetchVideos(completion: @escaping (Result<Videos, Error>) -> ()) {
        fetchData(with: StringConstants.videoURL, completion: completion)
    }
    

    func fetchData<T: Decodable>(with urlString: String, completion: @escaping(Result<T, Error>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")
//        with: request below
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let error = NSError(domain: "pbs", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
                return
            }
            
            do {
                let jsonData: T = try data.decoded()
                DispatchQueue.main.async {
                    completion(.success(jsonData))
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
