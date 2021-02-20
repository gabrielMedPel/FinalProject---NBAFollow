//
//  TeamsCollectionViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 08/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class TeamsCollectionViewController: UICollectionViewController {
    
    var teams: [Team] = []
    var delegate: TeamsCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        teams = GetData.shared.teams
        collectionView.reloadData()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return teams.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamLogocell", for: indexPath)
        
        if let cell = cell as? TeamCollectionViewCell{
            
            if teams.count > 0{
                let team = teams[indexPath.item]
                let url = "https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/\(team.tricode.lowercased()).png"
                
                cell.logoTeam.setImageWithUrl(url: url, cell: cell, row: indexPath.item)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell else {return}
        let team = teams[indexPath.item]
        guard let icon = cell.logoTeam.image else {return}
        
        let superView = collectionView.superview
        
        if let center = collectionView.layoutAttributesForItem(at: indexPath)?.center{
            let centerAfterModulu = collectionView.convert(center, to: superView)
            
            delegate?.didSelect(icon: icon, with: centerAfterModulu, team: team)
        }
    }
    
    
}

protocol TeamsCollectionViewDelegate {
    func didSelect(icon: UIImage, with center: CGPoint, team: Team)
}
