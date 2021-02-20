//
//  PlayerProfile.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 24/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBAPlayerProfileResponse: Codable {
    let league: ProfileLeague
}

struct ProfileLeague: Codable {
    let standard: ProfileStandard
}

struct ProfileStandard: Codable {
    let stats: ProfileStats
}

struct ProfileStats: Codable {
    let latest: Stats
    let careerSummary: Stats
    let regularSeason: RegularSeason
}

struct Stats: Codable {
    let ppg: String//Points per game
    let rpg: String//Rebounds per game
    let apg: String//assists per game
    let mpg: String//minutes per game
    let spg: String//steals per game
    let bpg: String//Blocks per game
    let tpp: String//3 pts percentage
    let ftp: String//Free Throw Percentage
    let fgp: String//Field Goal Percentage
    let assists: String//Assists
    let blocks: String//Blocks
    let steals: String//Steals
    let turnovers: String//Turnovers
    let offReb: String//Offensive Rebounds
    let defReb: String//Defensive Rebounds
    let totReb: String//Total Rebounds
    let fgm: String//Field Goals Made
    let fga: String//Field Goal Attempts
    let tpm: String//3 pts Made
    let tpa: String//3 pts attempts
    let ftm: String//Free Throws Made
    let fta: String//Free Throws attempts
    let pFouls: String//Fouls
    let points: String//Points
    let gamesPlayed: String
    let gamesStarted: String
    let plusMinus: String//Poits difference
    let min: String//Possession
    let dd2: String//Double Double
    let td3: String//Triple Doube
}

struct RegularSeason: Codable {
    let season: [Years]
}

struct Years: Codable {
    let seasonYear: Int
    let total: Stats
}
