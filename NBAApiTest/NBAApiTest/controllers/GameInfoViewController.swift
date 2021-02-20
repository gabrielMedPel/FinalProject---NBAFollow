//
//  GameInfoViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 29/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController {
    @IBOutlet weak var gameStatsInfoLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var vTeamImageView: UIImageView!
    
    @IBOutlet weak var hTeamImageView: UIImageView!
    
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var visitScoreLabel: UILabel!
    @IBOutlet weak var homefgp: UILabel!
    @IBOutlet weak var visitfgp: UILabel!
    @IBOutlet weak var hometpp: UILabel!
    @IBOutlet weak var visittpp: UILabel!
    @IBOutlet weak var homeftp: UILabel!
    @IBOutlet weak var visitftp: UILabel!
    @IBOutlet weak var homeAssists: UILabel!
    @IBOutlet weak var visitAssists: UILabel!
    @IBOutlet weak var homeRbts: UILabel!
    @IBOutlet weak var visitRbts: UILabel!
    @IBOutlet weak var homeBlocks: UILabel!
    @IBOutlet weak var visitBlocks: UILabel!
    @IBOutlet weak var homeSteals: UILabel!
    @IBOutlet weak var visitSteals: UILabel!
    @IBOutlet weak var homeTurnovers: UILabel!
    @IBOutlet weak var visitTurnovers: UILabel!
    @IBOutlet weak var toArticleButton: UIButton!
    
    var game: Game?
    var gameArticle: NBAGameArticleResponse?
    
    var allLabels = [[UILabel]]()
    
    
    @IBAction func toArticle(_ sender: UIButton) {
        performSegue(withIdentifier: "toArticle", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let game = game else {return}
        toArticleButton.layer.cornerRadius = 10
        
        GetData.shared.getGameInfo(game: game, vc: self)
        
        setLabelArrays()
        
       
    }
    
    func setLabelArrays(){
        let scoresL = [homeScoreLabel,visitScoreLabel]
        let fgpL = [homefgp,visitfgp]
        let ftpL = [homeftp,visitftp]
        let tppL = [hometpp,visittpp]
        let assistsL = [homeAssists,visitAssists]
        let reboundsL = [homeRbts,visitRbts]
        let turnoversL = [homeTurnovers,visitTurnovers]
        let blocksL = [homeBlocks,visitBlocks]
        let stealsL = [homeSteals,visitSteals]
        
        allLabels = [scoresL,fgpL,ftpL,tppL,assistsL,reboundsL,turnoversL,blocksL,stealsL] as! [[UILabel]]
    }
    
   
    
    func setGameInfo(gameInfo: NBAGameInfoResponse, gameStatus: String){
        if let stats = gameInfo.stats{
            let hScore: Int = Int(gameInfo.basicGameData.hTeam.score) ?? 0
            let hFgp: Int = Int(floor(Double(stats.hTeam.totals.fgp) ?? 0))
            let hTpp: Int = Int(floor(Double(stats.hTeam.totals.tpp) ?? 0))
            let hFtp: Int = Int(floor(Double(stats.hTeam.totals.ftp) ?? 0))
            let hAssists: Int = Int(stats.hTeam.totals.assists) ?? 0
            let hReb: Int = Int(stats.hTeam.totals.totReb) ?? 0
            let hBlocks: Int = Int(stats.hTeam.totals.blocks) ?? 0
            let hTurn: Int = Int(stats.hTeam.totals.turnovers) ?? 0
            let hSteals: Int = Int(stats.hTeam.totals.steals) ?? 0
            
            let vScore: Int = Int(gameInfo.basicGameData.vTeam.score) ?? 0
            let vFgp: Int = Int(floor(Double(stats.vTeam.totals.fgp) ?? 0))
            let vTpp: Int = Int(floor(Double(stats.vTeam.totals.tpp) ?? 0))
            let vFtp: Int = Int(floor(Double(stats.vTeam.totals.ftp) ?? 0))
            let vAssists: Int = Int(stats.vTeam.totals.assists) ?? 0
            let vReb: Int = Int(stats.vTeam.totals.totReb) ?? 0
            let vBlocks: Int = Int(stats.vTeam.totals.blocks) ?? 0
            let vTurn: Int = Int(stats.vTeam.totals.turnovers) ?? 0
            let vSteals: Int = Int(stats.vTeam.totals.steals) ?? 0
            
            homeScoreLabel.text = "\(hScore)"
            homefgp.text = "\(hFgp)"
            hometpp.text = "\(hTpp)"
            homeftp.text = "\(hFtp)"
            homeAssists.text = "\(hAssists)"
            homeRbts.text = "\(hReb)"
            homeBlocks.text = "\(hBlocks)"
            homeTurnovers.text = "\(hTurn)"
            homeSteals.text = "\(hSteals)"
            
            visitScoreLabel.text = "\(vScore)"
            visitfgp.text = "\(vFgp)"
            visittpp.text = "\(vTpp)"
            visitftp.text = "\(vFtp)"
            visitAssists.text = "\(vAssists)"
            visitRbts.text = "\(vReb)"
            visitBlocks.text = "\(vBlocks)"
            visitTurnovers.text = "\(vTurn)"
            visitSteals.text = "\(vSteals)"
            
            hTeamImageView.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(gameInfo.basicGameData.hTeam.triCode.lowercased()).png")
            vTeamImageView.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(gameInfo.basicGameData.vTeam.triCode.lowercased()).png")
            
            gameStatsInfoLabel.text = gameStatus
            gameDateLabel.text = dataConverter(dateStr: gameInfo.basicGameData.homeStartDate)
            
            //TODO: Melhorar colocando as variaveis ao inves das labels
            
            allLabels.forEach {
                guard let txt0 = $0[0].text else{return}
                guard let txt1 = $0[1].text else{return}
                guard let n0 = Int(txt0) else{return}
                guard let n1 = Int(txt1) else{return}
                
                $0[0].font = UIFont(name: "Arial Rounded MT Bold", size: 20)
                $0[1].font = UIFont(name: "Arial Rounded MT Bold", size: 20)
                if n0 > n1{
                    $0[0].textColor = #colorLiteral(red: 0.1560479403, green: 0.7475218177, blue: 0.08660384268, alpha: 1)
                    $0[1].textColor = #colorLiteral(red: 0.9877334237, green: 0.1151667014, blue: 0, alpha: 1)
                }else if n0 < n1{
                    $0[1].textColor = #colorLiteral(red: 0.1560479403, green: 0.7475218177, blue: 0.08660384268, alpha: 1)
                    $0[0].textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }else{
                    $0[1].textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                    $0[0].textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                }
            }
            visitfgp.text = "\(vFgp)%"
            visittpp.text = "\(vTpp)%"
            visitftp.text = "\(vFtp)%"
            homefgp.text = "\(hFgp)%"
            hometpp.text = "\(hTpp)%"
            homeftp.text = "\(hFtp)%"
            homeScoreLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 24)
            visitScoreLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 24)
        }
        
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameArticleViewController{
            dest.gameArticle = gameArticle
        }
        
    }
    func dataConverter(dateStr: String) -> String? {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
    
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MMM dd yyyy"
    
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
}
