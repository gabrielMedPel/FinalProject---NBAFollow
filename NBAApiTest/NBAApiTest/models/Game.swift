//
//  Game.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBAGamesResponse: Codable {
    let games:[Game]
}

struct Game: Codable {
    let gameId:String
    let arena:Arena
    let startTimeUTC: Date
    let vTeam: GameTeam
    let hTeam: GameTeam
    let isBuzzerBeater: Bool
    let isPreviewArticleAvail: Bool
    let isRecapArticleAvail: Bool
    let homeStartDate: String
    var isNotifying: Bool = false
    var notificationID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case gameId, arena, startTimeUTC, vTeam, hTeam, isBuzzerBeater, isPreviewArticleAvail, isRecapArticleAvail, homeStartDate
    }
}

struct Arena: Codable {
    let name:String
    let city:String
}

struct GameTeam: Codable {
    let teamId:String
    let triCode:String
    let win:String
    let loss:String
    let score:String
}
