//
//  PlayerTableViewCell.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 07/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    var link: PlayerTableViewController?
    
    @IBOutlet weak var playerPoster: UIImageView!
    @IBOutlet weak var teamLogo: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerTeamLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var starButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerPoster.image = nil
        teamLogo.image = nil
        playerNameLabel.text = ""
        playerTeamLabel.text = ""
        countryLabel.text = ""
        
    }
    
    func populate(with player: Player) {
        
        if player.teams.count != 0{
            if player.isFavorite{
                self.starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            }else{
                self.starButton.setImage(#imageLiteral(resourceName: "empty_star"), for: .normal)
            }
            
            self.playerNameLabel.text = player.firstName + " " + player.lastName
            self.countryLabel.text = player.country
            self.playerTeamLabel.text = player.teamName
            self.teamLogo.setImageWithUrl(url: player.teamLogo, cell: self, placeholder: nil)
            
            
            
            self.playerPoster.setImageWithUrl(url: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/\(player.personId).png", cell: self, placeholder:  UIImage(imageLiteralResourceName: "progress"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    @objc private func handleMarkAsFavorite(){
        link?.favoriteTapped(cell: self)
    }
    
}
