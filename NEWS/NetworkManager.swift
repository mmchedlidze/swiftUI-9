//
//  NetworkManager.swift
//  NEWS
//
//  Created by Mariam Mchedlidze on 28.12.23.
//

import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/everything?q=tesla&from=2023-11-27&sortBy=publishedAt&apiKey=ef27ba91fb4a459c9d550f0dad0612f2"

    private init() {}
    
    func fetchNews(completion: @escaping (Result<[News], Error>) -> Void ){
        let urlStr = baseURL
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain:"", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain:"", code: -2, userInfo: [ NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let newsResponse = try JSONDecoder().decode(Article.self, from: data)
                completion(.success(newsResponse.articles))
            } catch {
                completion(.failure(error))
            }
        } .resume()
    }
}
