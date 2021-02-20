//
//  GamesTableViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 10/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit
import ScrollableDatepicker
import UserNotifications

//TODO: Tentar trocar o link pelo delegate
class GamesTableViewController: UITableViewController {
    
    @IBAction func cancellnotificationsTapped(_ sender: UIBarButtonItem) {
        cancelAllNotification()
    }
    @IBOutlet weak var barNavigationItem: UINavigationItem!
    @IBOutlet weak var datepicker: ScrollableDatepicker! {
        didSet {
            var dates = [Date]()
            for day in -15...15 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datepicker.dates = dates
            datepicker.selectedDate = Date()
            datepicker.delegate = self
            
            var configuration = Configuration()
            
            // weekend customization
            configuration.weekendDayStyle.dateTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
            configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
            configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
            
            // selected date customization
            configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 1)
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datepicker.configuration = configuration
        }
    }
    
    var games: [Game] = []
    
    var coreData: Database{
        return Database.shared
    }
    
    @IBAction func myTeamTapped(_ sender: UIBarButtonItem) {
        Router.shared.openMenu(viewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "gameCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWithOptions(_:)), name: Notification.Name(rawValue: "updateWithOptions"), object: nil)
        
        DispatchQueue.main.async {
            self.getData(date: self.getSelectedDate())
        }
    }
    
    @objc func updateWithOptions(_ notification: Notification) {
        DispatchQueue.main.async {
            self.getData(date: self.getSelectedDate())
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        let game = games[indexPath.row]
        
        if let cell = cell as? GameTableViewCell{
            cell.link = self
            cell.populate(with: game)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toGameInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameInfoViewController{
            dest.game = games[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func notifyTapped(cell: UITableViewCell){
        
        guard let indexTapped = tableView.indexPath(for: cell) else{return}
        let game = games[indexTapped.row]
        
        if game.isNotifying{
            showCancelNotificationDialog(indexRow: indexTapped.row){ [weak self](cancelled) in
                guard let self = self else {return}
                if cancelled{
                    var gamesToNotify: [GameToNotify]{
                        return self.coreData.getGamesToNotify()
                    }
                    
                    for i in gamesToNotify.indices{
                        if game.gameId.contains(gamesToNotify[i].gameId){
                            self.coreData.deleteGameToNotify(gameToNotify: gamesToNotify[i])
                            break
                        }
                    }
                    
                    self.games[indexTapped.row].isNotifying = false
                    self.tableView.reloadData()
                }
            }
        }else{
            showNotificationDialog(indexRow: indexTapped.row){ [weak self](notificationUP) in
                guard let self = self else {return}
                if notificationUP {
                    
                    self.coreData.saveGameToNotify(game: GameToNotify(gameId: game.gameId))
                    self.games[indexTapped.row].isNotifying = true
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func showCancelNotificationDialog(indexRow: Int, handler: @escaping (Bool)->Void){
        let alertVC = UIAlertController(title: "Do you really want to miss the game?", message: "Cancel notification?", preferredStyle: .alert)
        alertVC.addAction(.init(title: "Yes", style: .default, handler: { (sender) in
            handler(true)
            self.cancelNotification(notificationID: self.games[indexRow].notificationID)
        }))
        alertVC.addAction(.init(title: "No", style: .cancel, handler: { (sender) in
            handler(false)
        }))
        present(alertVC, animated: true)
        
        
    }
    func showNotificationDialog(indexRow: Int, handler: @escaping (Bool)->Void){
        let alertVC = UIAlertController(title: "Choose your notification options:", message: "When do you want us to notify you?", preferredStyle: .alert)
        
        var date = games[indexRow].startTimeUTC
        print(date)
        var textTitle = ""
        
        alertVC.addAction(.init(title: "Exactly", style: .default, handler: { (sender) in
            textTitle = "You will be notifyied when the game starts!"
            handler(true)
            self.showResultDialog(txt: textTitle)
        }))
        alertVC.addAction(.init(title: "5 min", style: .default, handler: { (sender) in
            date = date.addingTimeInterval(-(5*60))
            textTitle = "You will be notifyied 5 minutes before the game starts!"
            handler(true)
            self.showResultDialog(txt: textTitle)
        }))
        alertVC.addAction(.init(title: "10 min", style: .default, handler: { (sender) in
            date = date.addingTimeInterval(-(10*60))
            textTitle = "You will be notifyied 10 minutes before the game starts!"
            handler(true)
            print(date)
            self.showResultDialog(txt: textTitle)
        }))
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: { (sender) in
            print("Canceled")
            textTitle = "You will not be notifyied!"
            handler(false)
            self.showResultDialog(txt: textTitle)
        }))
        present(alertVC, animated: true)
        setNotification(date: date, index: indexRow)
    }
    func showResultDialog(txt: String) {
        let alertVCResult = UIAlertController(title: txt, message: "", preferredStyle: .alert)
        alertVCResult.addAction(.init(title: "OK", style: .default, handler: { (sender) in
            
        }))
        self.present(alertVCResult, animated: true)
    }
    func setNotification(date: Date, index: Int) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil{
                print(error!)
            }
            
            if !granted{
                print("Sorry, we can't notify you!")
            }
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "The Game is about to start!"
        content.body = "GET UP!!"
        
        //        let date = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        games[index].notificationID = notificationID
        
        center.add(request) { (error) in
            if error != nil{
                print(error!)
            }
        }
    }
    func cancelNotification(notificationID: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])
        center.removeDeliveredNotifications(withIdentifiers: [notificationID])
    }
    func cancelAllNotification(){
        
        let alertVC = UIAlertController(title: "Do you really want to cancell all notifications?", message: "Cancel notifications?", preferredStyle: .alert)
        alertVC.addAction(.init(title: "Yes", style: .default, handler: { [weak self](sender) in
            if let self = self{
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                center.removeAllDeliveredNotifications()
                self.coreData.deleteAllNofifiedGames()
    
                for i in self.games.indices{
                    self.games[i].isNotifying = false
                }
                self.tableView.reloadData()
            }
            
        }))
        alertVC.addAction(.init(title: "No", style: .cancel, handler: {(sender) in
            alertVC.dismiss(animated: true)
        }))
        present(alertVC, animated: true)
        
        
        
    }
    
    //Scrollable Date Picker
    func getSelectedDate() -> String{
        if let selectedDate = datepicker.selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM YYYY"
            barNavigationItem.title = formatter.string(from: selectedDate)
            
            formatter.dateFormat = "yyyyMMdd"
            
            return formatter.string(from: selectedDate)
            
        }
        
        return ""
    }
    
    // MARK: - Table view data source
    func getData(date: String) {
        let ds = GameDataSource()
        
        ds.getGames(date: date) { [weak self](gameInfo, err) in
            if err != nil{
                print(err!)
            }
            if let self = self{
                if var games = gameInfo?.games{
                    self.games = games
                    var gamesToNotify: [GameToNotify]{
                        return self.coreData.getGamesToNotify()
                    }
                    var favTeam: [FavoriteTeam]{
                        return self.coreData.getFavoriteTeam()
                    }
                    
                    if favTeam.count > 0, favTeam[0].onlyMyTeamInfo, let favoriteTeamID = favTeam[0].teamId{
                        self.games.removeAll{
                            $0.hTeam.teamId != favoriteTeamID && $0.vTeam.teamId != favoriteTeamID
                        }
                    }
                    
                    gamesToNotify.forEach({ (gameToNotify) in
                        for i in self.games.indices{
                            if self.games[i].gameId.contains(gameToNotify.gameId){
                                self.games[i].isNotifying = true
                            }
                        }
                    })
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
}

extension GamesTableViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        DispatchQueue.main.async {
            self.getData(date: self.getSelectedDate())
        }
    }
    
}






