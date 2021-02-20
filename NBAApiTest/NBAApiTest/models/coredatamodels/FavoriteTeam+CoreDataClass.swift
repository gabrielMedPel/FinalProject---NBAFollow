//
//  FavoriteTeam+CoreDataClass.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 10/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoriteTeam)
public class FavoriteTeam: NSManagedObject {

    convenience init(teamId: String, onlyMyTeamInfo: Bool = false, teamName: String){
        self.init(context: Database.shared.context)
        
        self.onlyMyTeamInfo = onlyMyTeamInfo
        self.teamId = teamId
        self.teamName = teamName
        
    }
}
