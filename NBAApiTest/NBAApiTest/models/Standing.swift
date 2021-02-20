//
//  Standing.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 17/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

struct NBAStandingResponse: Codable{
    let league: StandingLeague
}

struct StandingLeague: Codable {
    let standard: StandardLeague
}
struct StandardLeague: Codable {
    let conference: Conference
}
struct Conference: Codable{
    let east: [StandingTeam]
    let west: [StandingTeam]
}

struct StandingTeam: Codable {
    let teamId: String
    let win: String
    let loss: String
    let winPctV2: String
    let confRank: String
    let lastTenWin: String
    let lastTenLoss: String
    let streak: String
    let teamSitesOnly: TeamStand
    
}

struct TeamStand: Codable {
    let teamName:String
    let teamNickname:String
    let teamTricode:String
    let streakText:String
    
}
