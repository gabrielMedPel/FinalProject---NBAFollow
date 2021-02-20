//
//  FavoritePlayers+CoreDataProperties.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritePlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePlayer> {
        return NSFetchRequest<FavoritePlayer>(entityName: "FavoritePlayer")
    }

    @NSManaged public var personId: String

}
