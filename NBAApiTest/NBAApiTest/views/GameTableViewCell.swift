//
//  GameTableViewCell.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 15/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    var link: GamesTableViewController?
    
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var visitTeamImage: UIImageView!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var visitTeamLabel: UILabel!
    @IBOutlet weak var homeWLLabel: UILabel!
    @IBOutlet weak var visitWLLabel: UILabel!
    @IBOutlet weak var gameHourLabel: UILabel!
   
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var notifyMeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeTeamImage.image = nil
        visitTeamImage.image = nil
        homeTeamLabel.text = ""
        visitTeamLabel.text = ""
        stadiumLabel.text = ""
        homeWLLabel.text = ""
        visitWLLabel.text = ""
        gameHourLabel.text = ""
        notifyButton.alpha = 1
        notifyMeLabel.alpha = 1
        notifyMeLabel.text = ""
    }
    
    func populate(with game: Game) {
        homeTeamImage.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(game.hTeam.triCode.lowercased()).png", cell: self, placeholder:  UIImage(imageLiteralResourceName: "progress"))
        visitTeamImage.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(game.vTeam.triCode.lowercased()).png", cell: self, placeholder: UIImage(imageLiteralResourceName: "progress"))
        homeTeamLabel.text = game.hTeam.triCode
        visitTeamLabel.text = game.vTeam.triCode
        
        let date = game.startTimeUTC
       
        if game.startTimeUTC.timeIntervalSinceNow > 0{
            stadiumLabel.text = game.arena.name + " - " + game.arena.city
            homeWLLabel.text = "\(game.hTeam.win)W - \(game.hTeam.loss)L"
            visitWLLabel.text = "\(game.vTeam.win)W - \(game.vTeam.loss)L"

            if game.isNotifying{
                notifyButton.setImage(#imageLiteral(resourceName: "alarm_cancel"), for: .normal)
                notifyMeLabel.text = "Cancel"
            }else{
                notifyButton.setImage(#imageLiteral(resourceName: "alarm"), for: .normal)
                notifyMeLabel.text = "Notify Me"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"

            gameHourLabel.text = dateFormatter.string(from: date)
        }else{
            notifyButton.alpha = 0
            notifyMeLabel.alpha = 0
            stadiumLabel.text = ""
            homeWLLabel.text = "\(game.hTeam.score)"
            visitWLLabel.text = "\(game.vTeam.score)"
            gameHourLabel.text = "Final"
            homeTeamLabel.topAnchor.constraint(equalTo: homeTeamImage.bottomAnchor, constant: 8)
            visitTeamLabel.topAnchor.constraint(equalTo: visitTeamImage.bottomAnchor, constant: 8)
            
            if game.isBuzzerBeater{
                stadiumLabel.text = "Buzzer Beater!!"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notifyButton.addTarget(self, action: #selector(handleMarkNotify), for: .touchUpInside)
    }
    
    @objc private func handleMarkNotify(){
        link?.notifyTapped(cell: self)
    }
    
}
