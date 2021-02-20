//
//  GetData.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 13/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class GetData{
    var teams: [Team] = []
    var players:[Player] = []
    var filteredPlayers:[Player] = []
    var myTeamPlayers: [Player]?
    var standingTeamsEast:[StandingTeam] = []
    var standingTeamsWest:[StandingTeam] = []
    var articles:[Article] = []
    var playerStats: ProfileStats?
    
    
    static var shared = GetData()
    private init(){}
    
    func allPlayers(){
        let favoritePlayers = Database.shared.getFavoritePlayers()
        let ds = NbaDataSource()
        ds.getPlayers {[weak self] (nbaInfo, err) in
            if err != nil {
                print(err!)
            }
            if var players = nbaInfo?.league.standard{
               
                if favoritePlayers != []{
                    for i in players.indices{
                        if players[i].teams.count != 0{
                            favoritePlayers.forEach{
                                if $0.personId.contains(players[i].personId){
                                    
                                    players[i].isFavorite = true
                                }
                            }
                        }
                    }
                }
                
                self?.filteredPlayers = players
                self?.players = players
                
                let tds = TeamDataSource()
                tds.getTeams { [weak self](teamInfo, err) in
                    if let teams = teamInfo?.league.standard{
                        self?.teams = teams
                        
                        guard let self = self else {return}
                        //Pensar em melhorar isso:
                        for team in teams{
                            for i in self.filteredPlayers.indices{
                                let player = self.filteredPlayers[i]
                                if player.teams.count != 0{
                                    if player.teams[player.teams.count-1].teamId == team.teamId{
                                        self.filteredPlayers[i].teamName = team.fullName
                                        self.filteredPlayers[i].teamLogo = "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(team.tricode.lowercased()).png"
                                        
                                    }
                                }
                            }
                            for i in self.players.indices{
                                let player = self.players[i]
                                if player.teams.count != 0{
                                    if player.teams[player.teams.count-1].teamId == team.teamId{
                                        self.players[i].teamName = team.fullName
                                        self.players[i].teamLogo = "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(team.tricode.lowercased()).png"
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
                self?.filteredPlayers.removeAll{$0.teams.count == 0}
                self?.players.removeAll{$0.teams.count == 0}
                
                
                if Database.shared.getFavoriteTeam().count > 0, Database.shared.getFavoriteTeam()[0].onlyMyTeamInfo{
                    
                    if let favoriteTeam = Database.shared.getFavoriteTeam()[0].teamId{
                        self?.filteredPlayers = []
                        for player in players{
                            if player.teams.count > 0{
                                if player.teams[player.teams.count - 1].teamId.contains(favoriteTeam){
                                    self?.filteredPlayers.append(player)
                                    
                                }
                                
                            }
                           
                        }
                        self?.myTeamPlayers = self?.filteredPlayers
                       
                    }
                }
            }
        }
    }
    
    func getStandings(){
        let ds = StandingsDataSource()
        ds.getStandings { [weak self](standingInfo, err) in
            if err != nil{
                print(err!)
            }
            
            if let teams = standingInfo?.league.standard.conference.east{
                self?.standingTeamsEast = teams
                
            }
            if let teams = standingInfo?.league.standard.conference.west{
                self?.standingTeamsWest = teams
                
            }
        }
    }
    
    func getPlayerStats(player: Player?, vc: UIViewController){
        let ds = PlayerProfileDataSource()
        guard let player = player else {return}
        ds.getPlayerProfile(personId: player.personId) {[weak self] (profileResponse, err) in
            if err != nil{
                print(err!)
            }
            if let playerStats = profileResponse?.league.standard.stats{
                self?.playerStats = playerStats
                
                if let vc = vc as? PlayerInfoViewController{
                    vc.fillArrays()
                    vc.putInfo()
                    vc.getStats()
                    vc.putStats()
                    
                    
                }
                
                
            }
        }
    }
    
    func getNews(txt: String, vc: UITableViewController){
        let ds = NewsDataSource()
        ds.getNews(txt: txt) { [weak self](nbaNews, err) in
            if err != nil{
                print(err!)
            }
            if let articles = nbaNews?.articles{
                self?.articles = articles
                
                if let vc = vc as? NewsTableViewController{
                    vc.articles = articles
                    vc.tableView.reloadData()
                    vc.showSuccess(title: "Done!!")
                }
               
            }
        }
    }
    
    func getGameInfo(game: Game, vc: UIViewController){
        let ds = GameInfoDataSource()
        guard let vc = vc as? GameInfoViewController else {return}
        ds.getGameInfo(date: game.homeStartDate, gameId: game.gameId) { (nbaGameInfoResponse, err) in
            if err != nil{
                print(err!)
            }
            if let newGameInfo = nbaGameInfoResponse{
                if game.isPreviewArticleAvail && game.isRecapArticleAvail {
                    self.getGameArticle(gameInfo: newGameInfo, gameStatus: "Game Stats:", articleTxt: "Recap Article", articleType: .recap, vc: vc)
                    
                }else{
                    
                    ds.getGameInfo(date: newGameInfo.previousMatchup.gameDate, gameId: newGameInfo.previousMatchup.gameId) { (nbaGameInfoResponse, err) in
                        if err != nil{
                            print(err!)
                        }
                        if let newPreviousGameInfo = nbaGameInfoResponse{
                            self.getGameArticle(gameInfo: newPreviousGameInfo, gameStatus: "Previous Matchup Stats:", articleTxt: "Preview Article", articleType: .preview, vc: vc)
                        }
                    }
                }
            }
        }
    }
    
    func getGameArticle(gameInfo: NBAGameInfoResponse, gameStatus: String, articleTxt: String, articleType: ArticleDataSource.ArticleType, vc: UIViewController){
        
        let ds = ArticleDataSource()
        ds.getGameArticle(date: gameInfo.basicGameData.homeStartDate, gameId: gameInfo.basicGameData.gameId, articleType: articleType) { (nbaArticleResponse, err) in
            if err != nil{
                print(err!)
            }
            if let gameArticle = nbaArticleResponse{
                if let vc = vc as? GameInfoViewController{
                   vc.toArticleButton.setTitle(articleTxt, for: .normal)
                    vc.toArticleButton.isEnabled = true
                    vc.gameArticle = gameArticle
                    vc.setGameInfo(gameInfo: gameInfo, gameStatus: gameStatus)
                }
                
            }
        }
    }
}
