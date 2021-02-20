//
//  Database.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 08/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import CoreData

class Database {
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NBAApiTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Out of disk space")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    //Singleton:
    private init(){}
    static let shared = Database()
    
    //Methods:
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveFavoriteTeam(team: FavoriteTeam){
        
        saveContext()
    }
    
    func saveFavoritePlayers(favoritePlayers: FavoritePlayer){
        
        saveContext()
    }
    
    func saveGameToNotify(game: GameToNotify){
        
        saveContext()
    }
    
    func getFavoriteTeam()->[FavoriteTeam]{
        let request: NSFetchRequest<FavoriteTeam> = FavoriteTeam.fetchRequest()
        
        if let team = try? context.fetch(request){
            return team
        }
        
        return []
    }
    
    func getFavoritePlayers()->[FavoritePlayer]{
        let request: NSFetchRequest<FavoritePlayer> = FavoritePlayer.fetchRequest()
        
        if let favoritePlayers = try? context.fetch(request){
            return favoritePlayers
        }
        
        return []
    }
    func getGamesToNotify()->[GameToNotify]{
        let request: NSFetchRequest<GameToNotify> = GameToNotify.fetchRequest()
        
        if let gamesToNotify = try? context.fetch(request){
            return gamesToNotify
        }
        
        return []
    }
    
    func deleteFavoritePlayer(favoritePlayer: FavoritePlayer){
        context.delete(favoritePlayer)
        saveContext()
    }
    func deleteGameToNotify(gameToNotify: GameToNotify){
        context.delete(gameToNotify)
        saveContext()
    }
    func deleteAllNofifiedGames(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GameToNotify")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("Error")
        }
    }
}
