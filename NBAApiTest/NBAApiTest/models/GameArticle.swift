//
//  GameArticle.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 01/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBAGameArticleResponse: Codable {
    let author:String?
    let authorTitle:String
    let copyright:String
    let title:String
    let pubDateUTC:Date?
    let paragraphs: [Paragraph]
}

struct Paragraph:Codable {
    let paragraph: String
}
