//
//  FavoriteTeam+CoreDataProperties.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 10/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteTeam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTeam> {
        return NSFetchRequest<FavoriteTeam>(entityName: "FavoriteTeam")
    }

    @NSManaged public var onlyMyTeamInfo: Bool
    @NSManaged public var teamId: String?
    @NSManaged public var teamName: String?

}
