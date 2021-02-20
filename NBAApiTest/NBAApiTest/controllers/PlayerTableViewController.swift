//
//  PlayerTableViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 07/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class PlayerTableViewController: UITableViewController, UISearchBarDelegate{
    var teams: [Team] = []
    var players:[Player] = []
    var filteredPlayers:[Player] = []
    var myTeamPlayers: [Player]?
    var favoritesPlayers:[Player] = []
    var data: GetData{
        return GetData.shared
    }
    var coreData: Database{
        return Database.shared
    }
    
    
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBAction func myTeamTapped(_ sender: UIBarButtonItem) {
        Router.shared.openMenu(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithOptions(_:)), name: Notification.Name(rawValue: "updateWithOptions"), object: nil)
        
    }
    
    func setData(){
        teams = data.teams
        players = data.players
        filteredPlayers = data.filteredPlayers
        sortByPlayer()
        myTeamPlayers = data.myTeamPlayers
        players.forEach{
            if $0.isFavorite{
                favoritesPlayers.append($0)
            }
        }
        
        if coreData.getFavoriteTeam().count > 0, coreData.getFavoriteTeam()[0].onlyMyTeamInfo{
            searchField.showsScopeBar = false
            searchField.selectedScopeButtonIndex = 0
        }else{
            searchField.showsScopeBar = true
        }
        tableView.reloadData()
    }
    
    //MARK: - Func called from the cell
    
    func favoriteTapped(cell: UITableViewCell){
        
        guard let indexTapped = tableView.indexPath(for: cell) else{return}
        
        var playerFav = filteredPlayers[indexTapped.row]
        
        if !playerFav.isFavorite{
            print("Favorite")
            filteredPlayers[indexTapped.row].isFavorite = true
            for i in players.indices{
                if playerFav.personId == players[i].personId{
                    players[i].isFavorite = true
                }
            }
            playerFav.isFavorite = true
            favoritesPlayers.append(playerFav)
            coreData.saveFavoritePlayers(favoritePlayers: FavoritePlayer(personId: playerFav.personId))
            
            
        }else{
            playerFav.isFavorite = false
            print("UnFavorite")
            var favPlayers: [FavoritePlayer]{
                return coreData.getFavoritePlayers()
            }
            for i in favPlayers.indices{
                if favPlayers[i].personId.contains(playerFav.personId){
                    coreData.deleteFavoritePlayer(favoritePlayer: favPlayers[i])
                    break
                }
            }
            filteredPlayers[indexTapped.row].isFavorite = false
            for i in players.indices{
                if playerFav.personId == players[i].personId{
                    players[i].isFavorite = false
                }
            }
            if searchField.selectedScopeButtonIndex == 3{
                //When in the Favorite tab
                if filteredPlayers.count == 1{
                    filteredPlayers.removeAll()
                    favoritesPlayers.removeAll()
                }else{
                    for i in 0..<filteredPlayers.count{
                        if playerFav.personId == filteredPlayers[i].personId{
                            filteredPlayers.remove(at: i)
                            favoritesPlayers.remove(at: i)
                            break
                        }
                    }
                }
                tableView.deleteRows(at: [indexTapped], with: .fade)
            }else{
                favoritesPlayers.removeAll{$0.personId == playerFav.personId}
            }
        }
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredPlayers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? PlayerTableViewCell{
            cell.link = self
            
            let player = filteredPlayers[indexPath.row]
            
            cell.populate(with: player)
        }
        return cell
    }
    
    //MARK: SearchBar Config:
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if coreData.getFavoriteTeam()[0].onlyMyTeamInfo{
            
            filteredPlayers = []
            
            if searchText == ""{
                filteredPlayers = myTeamPlayers!
                
            }else{
                for player in myTeamPlayers! {
                    
                    if player.firstName.lowercased().contains(searchText.lowercased()) || player.lastName.lowercased().contains(searchText.lowercased()){
                        filteredPlayers.append(player)
                        
                    }
                }
            }
            sortByPlayer()
        }else{
            filteredPlayers = []
            
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText == ""{
                    filteredPlayers = players
                    
                }else{
                    for player in players {
                        
                        if player.firstName.lowercased().contains(searchText.lowercased()) || player.lastName.lowercased().contains(searchText.lowercased()){
                            filteredPlayers.append(player)
                            
                        }
                    }
                }
                sortByPlayer()
            case 1:
                if searchText == ""{
                    filteredPlayers = players
                    
                }else{
                    for player in players {
                        
                        if player.teamName.lowercased().contains(searchText.lowercased()){
                            filteredPlayers.append(player)
                            
                        }
                    }
                }
                sortByTeam()
            case 2:
                if searchText == ""{
                    filteredPlayers = players
                    
                }else{
                    for player in players {
                        
                        if player.country.lowercased().contains(searchText.lowercased()){
                            filteredPlayers.append(player)
                            
                        }
                    }
                }
                sortByCountry()
            case 3:
                if searchText == ""{
                    filteredPlayers = favoritesPlayers
                    
                }else{
                    for player in players {
                        
                        if player.firstName.lowercased().contains(searchText.lowercased()) || player.lastName.lowercased().contains(searchText.lowercased()) ||
                            player.teamName.lowercased().contains(searchText.lowercased()) ||
                            player.country.lowercased().contains(searchText.lowercased()){
                            favoritesPlayers.append(player)
                            
                        }
                    }
                }
                sortByPlayer()
            default:
                sortByPlayer()
            }
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filteredPlayers = players
        searchBar.text = ""
        
        switch selectedScope {
        case 0:
            sortByPlayer()
        case 1:
            sortByTeam()
        case 2:
            sortByCountry()
        case 3:
            filteredPlayers = favoritesPlayers
            sortByPlayer()
        default:
            sortByPlayer()
        }
        tableView.reloadData()
    }
    
    func sortByPlayer(){
        filteredPlayers.sort {
            $0.firstName < $1.firstName
        }
        
    }
    func sortByTeam() {
        print("Sorted by team")
        filteredPlayers.sort {
            if $0.teams.count != 0 && $1.teams.count != 0{
                return $0.teams[$0.teams.count - 1].teamId < $1.teams[$1.teams.count - 1].teamId
            }
            return false
        }
    }
    func sortByCountry() {
        filteredPlayers.sort {
            if $0.country.count != 0 && $1.country.count != 0{
                return $0.country < $1.country
            }
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPlayerInfo", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let dest = segue.destination as? PlayerInfoViewController{
            dest.player = filteredPlayers[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }
    
    
    @objc func updateWithOptions(_ notification: Notification) {
        
        if let favoriteTeam = coreData.getFavoriteTeam()[0].teamId, coreData.getFavoriteTeam()[0].onlyMyTeamInfo{
            searchField.selectedScopeButtonIndex = 0
            searchField.showsScopeBar = false
            filteredPlayers = []
            for player in players{
                if player.teams.count != 0{
                    if player.teams[player.teams.count - 1].teamId.contains(favoriteTeam){
                        filteredPlayers.append(player)
                        
                    }
                }
            }
            myTeamPlayers = filteredPlayers
        }else{
            filteredPlayers = players
            searchField.showsScopeBar = true
            
        }
        sortByPlayer()
        tableView.reloadData()
    }
}









