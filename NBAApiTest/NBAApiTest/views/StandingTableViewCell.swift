//
//  StandingTableViewCell.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 17/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class StandingTableViewCell: UITableViewCell {

    @IBOutlet weak var logoTeamImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var percLabel: UILabel!
    @IBOutlet weak var confRankLabel: UILabel!
    
    var favoriteTeam: [FavoriteTeam]{
        return Database.shared.getFavoriteTeam()
    }
    
    
    func populate(with team: StandingTeam, counter: Int) {
        self.teamNameLabel.text = team.teamSitesOnly.teamNickname
        self.winLabel.text = team.win
        self.lossLabel.text = team.loss
        self.percLabel.text = "\(team.winPctV2)%"
        self.confRankLabel.text = team.confRank
        
        self.logoTeamImageView.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(team.teamSitesOnly.teamTricode.lowercased()).png")
        
       
        if counter <= 8{
            self.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.2)
        }else if counter <= 15{
            self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
        }
        
        
        if favoriteTeam.count > 0, favoriteTeam[0].onlyMyTeamInfo, favoriteTeam[0].teamId == team.teamId{
            self.layer.borderWidth = 4
            self.layer.borderColor = UIColor.red.cgColor
        }else{
            self.layer.borderWidth = 0
        }
        
    }
}
