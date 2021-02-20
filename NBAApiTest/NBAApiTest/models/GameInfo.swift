//
//  GameInfo.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 31/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBAGameInfoResponse:Codable {
    let basicGameData: Game
    let previousMatchup: PreviousMatchup
    let stats: GameInfoStats?
}

struct PreviousMatchup: Codable {
    let gameId: String
    let gameDate: String
}

struct GameInfoStats: Codable {
    let vTeam: GameInfoTeamStats
    let hTeam: GameInfoTeamStats
}

struct GameInfoTeamStats:Codable {
    let totals: TotalStats
}

struct TotalStats:Codable {
    let points: String
    let fgp: String
    let ftp: String
    let tpp: String
    let totReb: String
    let assists: String
    let steals: String
    let turnovers: String
    let blocks: String
    
}
