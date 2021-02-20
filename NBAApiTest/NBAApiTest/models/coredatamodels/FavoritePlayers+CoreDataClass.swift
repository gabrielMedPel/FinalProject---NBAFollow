//
//  FavoritePlayers+CoreDataClass.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoritePlayer)
public class FavoritePlayer: NSManagedObject {

    convenience init(personId: String){
        self.init(context: Database.shared.context)
        
        self.personId = personId
    }
}
