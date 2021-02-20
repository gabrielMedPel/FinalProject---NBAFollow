//
//  Team.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 09/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import Foundation


struct NBATeamsResponse:Codable{
    let league: TeamLeague
}

struct TeamLeague:Codable {
    let standard: [Team]
}

struct Team: Codable {
    let teamId:String
    let fullName:String
    let tricode:String
    let urlName: String
}


