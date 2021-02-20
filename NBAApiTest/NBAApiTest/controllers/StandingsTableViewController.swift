//
//  StandingsTableViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 17/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

//TODO: Adiconar favorite Team em destaque
class StandingsTableViewController: UITableViewController {
    var standingTeams:[StandingTeam] = []
    var counter = 0
    
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            standingTeams = GetData.shared.standingTeamsEast
        case 1:
            standingTeams = GetData.shared.standingTeamsWest
        default:
            standingTeams = GetData.shared.standingTeamsEast
        }
        tableView.reloadData()
    }
    
    
    @IBAction func myTeamTapped(_ sender: UIBarButtonItem) {
        Router.shared.openMenu(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StandingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "standingCell")
        
        standingTeams = GetData.shared.standingTeamsEast
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithOptions(_:)), name: Notification.Name(rawValue: "updateWithOptions"), object: nil)
        
        
        
    }
    
    
    @objc func updateWithOptions(_ notification: Notification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return standingTeams.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingCell", for: indexPath)
        
        let standingTeam = standingTeams[indexPath.row]
        counter = counter + 1
        
        
        if let cell = cell as? StandingTableViewCell{
            cell.populate(with: standingTeam, counter: counter)
            
            // Configure the cell...
        }
        if counter == 15{
            counter = 0
        }
        return cell
    }
    
}

