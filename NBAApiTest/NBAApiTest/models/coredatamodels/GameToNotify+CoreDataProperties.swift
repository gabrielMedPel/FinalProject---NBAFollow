//
//  GameToNotify+CoreDataProperties.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData


extension GameToNotify {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameToNotify> {
        return NSFetchRequest<GameToNotify>(entityName: "GameToNotify")
    }

    @NSManaged public var gameId: String

}
