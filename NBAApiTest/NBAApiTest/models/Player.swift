//
//  Player.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 07/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation

//TODO: Adicionar enum para favoritos

struct NBAPlayerResponse: Codable {
    let league: PlayerLeague
}

struct PlayerLeague:Codable {
    let standard: [Player]
}

struct Player: Codable {
    let firstName: String
    let lastName: String
    let personId: String
    let jersey: String
    let pos: String
    let heightMeters: String
    let weightKilograms: String
    let country: String
    var teams: [PlayerTeamId]
    var isFavorite: Bool = false
    var teamName:String = ""
    var teamLogo:String = ""
    let dateOfBirthUTC: String
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, personId, jersey, pos, heightMeters, weightKilograms, country, teams, dateOfBirthUTC
    }
}
struct PlayerTeamId:Codable {
    var teamId:String
    

}
