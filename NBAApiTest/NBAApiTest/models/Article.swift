//
//  Article.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 18/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBANewsResponse: Codable {
    let articles:[Article]
}

struct Article:Codable {
    let author:String?
    let title:String
    let description:String?
    let url:String
    let urlToImage:String?
    let publishedAt:Date
    
    
}
