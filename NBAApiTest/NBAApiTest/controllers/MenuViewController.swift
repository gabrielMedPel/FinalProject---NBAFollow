//
//  MenuViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 05/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var favoriteTeamArray: [FavoriteTeam]?{
        return Database.shared.getFavoriteTeam()
    }
    
    @IBOutlet weak var onlyMyTeamSwitch: UISwitch!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            heightConstraint.constant = 0
        }
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        if let favoriteTeamArray = favoriteTeamArray, favoriteTeamArray.count > 0{
             NotificationCenter.default.post(name: Notification.Name(rawValue: "updateWithOptions"), object: nil)
        }
        
       
        dismiss(animated: true)
    }
    @IBAction func logoTapped(_ sender: UIButton) {
        
        heightConstraint.constant =  heightConstraint.constant > 0 ? 0 : 116
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {[weak self] in
            self?.view.layoutIfNeeded()
        })
        chooseLabel.alpha = 1
    }
    @IBAction func toggleChanged(_ sender: UISwitch) {
        guard let favoriteTeamArray = favoriteTeamArray else {return}
        
        if favoriteTeamArray.count > 0{
            favoriteTeamArray[0].onlyMyTeamInfo = sender.isOn
            Database.shared.saveContext()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favoriteTeamArray = favoriteTeamArray, favoriteTeamArray.count > 0{
            onlyMyTeamSwitch.isEnabled = true
            onlyMyTeamSwitch.isOn = favoriteTeamArray[0].onlyMyTeamInfo
            let ds = TeamDataSource()
            ds.getTeams { [weak self](teamsResponse, error) in
                if error != nil{
                    print(error!)
                }
                if let teams = teamsResponse?.league.standard{
                    if let actualFavoriteTeam = teams.first(where: {
                        $0.teamId == favoriteTeamArray[0].teamId
                    }){
                        self?.logoButton.setImageWithUrl(url: "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(actualFavoriteTeam.tricode.lowercased()).png")
                    }
                }
            }
            
        }else{
            onlyMyTeamSwitch.isOn = false
            onlyMyTeamSwitch.isEnabled = false
            logoButton.setImage(UIImage(imageLiteralResourceName: "cross"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teamsVC = segue.destination as? TeamsCollectionViewController else {return}
        
        teamsVC.delegate = self
    }
    
}

extension MenuViewController: TeamsCollectionViewDelegate{
    func didSelect(icon: UIImage, with center: CGPoint, team: Team) {
        onlyMyTeamSwitch.isEnabled = true
        let imageView = UIImageView(image: icon)
        imageView.center = center
        imageView.center.y = view.frame.height - heightConstraint.constant / 2
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [], animations: {[weak self] in
            imageView.center = self?.logoButton.center ?? .zero
            imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self?.logoButton.alpha = 0
        }) {[weak self] (completed) in
            self?.logoButton.setImage(imageView.image, for: .normal)
            self?.logoButton.alpha = 1
            imageView.removeFromSuperview()
            if let favoriteTeamArray = self?.favoriteTeamArray{
                if favoriteTeamArray.count > 0{
                    favoriteTeamArray[0].setValue(team.teamId, forKey: "teamId")
                    favoriteTeamArray[0].setValue((self?.onlyMyTeamSwitch.isOn)!, forKey: "onlyMyTeamInfo")
                    favoriteTeamArray[0].setValue(team.urlName, forKey: "teamName")
                    Database.shared.saveContext()
                    //                    self?.favoriteTeam.setValue(team.teamId, forKey: "teamId")
                    //                    self?.favoriteTeam.setValue((self?.onlyMyTeamSwitch.isOn)!, forKey: "onlyMyTeamInfo")
                }else{
                    Database.shared.saveFavoriteTeam(team: FavoriteTeam(teamId: team.teamId, onlyMyTeamInfo: (self?.onlyMyTeamSwitch.isOn)!, teamName: team.urlName))
                }
                
            }
        }
    }
}
