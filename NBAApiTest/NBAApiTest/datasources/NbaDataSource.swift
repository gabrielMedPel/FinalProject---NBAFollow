//
//  NbaDataSource.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 07/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation


struct NbaDataSource {
    let baseUrl = "https://data.nba.net"
    
    func getPlayers(callback: @escaping (NBAPlayerResponse?, NBAError?)->Void) {
        
        
        guard let url = URL(string: "\(baseUrl)/data/10s/prod/v1/2020/players.json")else {
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
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let nbaInfo = try decoder.decode(NBAPlayerResponse.self, from: data)
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
