//
//  NewsTableViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 18/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit
import PKHUD


class NewsTableViewController: UITableViewController {
    var articles:[Article] = []
    
    @IBAction func myTeamTapped(_ sender: UIBarButtonItem) {
        Router.shared.openMenu(viewController: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgress(title: "Getting the news...")
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "newsCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithOptions(_:)), name: Notification.Name(rawValue: "updateWithOptions"), object: nil)
        
        getData()
    }
    
    func getData() {
        var favoriteTeam: [FavoriteTeam]{
            return Database.shared.getFavoriteTeam()
        }
        var txt = "nba"
        if favoriteTeam.count > 0 ,favoriteTeam[0].onlyMyTeamInfo{
            if let newTxt = favoriteTeam[0].teamName {
                txt = newTxt
            }
        }
        
        GetData.shared.getNews(txt: txt, vc: self)
    }
    
    @objc func updateWithOptions(_ notification: Notification) {
        showProgress(title: "Getting the news...")
        getData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        let article = articles[indexPath.row]
        
        if let cell = cell as? NewsTableViewCell{
            cell.populate(with: article)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: articles[indexPath.row].url) else {return}
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
