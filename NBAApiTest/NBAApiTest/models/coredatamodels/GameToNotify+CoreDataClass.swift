//
//  GameToNotify+CoreDataClass.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GameToNotify)
public class GameToNotify: NSManagedObject {

    convenience init(gameId: String){
        self.init(context: Database.shared.context)
        
        self.gameId = gameId
    }
}
