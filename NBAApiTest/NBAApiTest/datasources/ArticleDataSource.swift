//
//  ArticleDataSource.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 01/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct ArticleDataSource {
    
    enum ArticleType: String {
        case preview = "_preview_article.json"
        case recap = "_recap_article.json"
        
        
    }
    
     let baseUrl = "https://data.nba.net"
    
    func getGameArticle(date: String, gameId: String, articleType: ArticleType, callback: @escaping (NBAGameArticleResponse?, NBAError?)->Void) {
        
       let urlString = "\(baseUrl)/data/10s/prod/v1/\(date)/\(gameId)\(articleType.rawValue)"
        print(baseUrl)
        
        guard let url = URL(string: urlString)else {
            DispatchQueue.main.async {callback(nil, .urlError)}
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err{
                DispatchQueue.main.async {callback(nil, .serverAccessError(cause: err))}
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                DispatchQueue.main.async {callback(nil, .notHttpRequest)}
                return
            }
            
            guard (200...299).contains(res.statusCode) else{
                DispatchQueue.main.async {callback(nil, .httpError(statusCode: res.statusCode))}
                return
            }
            
            guard let data = data else{
                DispatchQueue.main.async {callback(nil, .noData)}
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                //                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let nbaInfo = try decoder.decode(NBAGameArticleResponse.self, from: data)
                DispatchQueue.main.async {callback(nbaInfo, nil)}
                
            }catch let err{
                DispatchQueue.main.async {callback(nil, .jsonDecodingError(cause: err))}
            }
            
            }.resume()
    }
    
    enum NBAError:Error {
        case urlError
        case serverAccessError(cause: Error)
        case httpError(statusCode: Int)
        case notHttpRequest
        case noData
        case jsonDecodingError(cause: Error)
        
    }
}
