//
//  PlayerInfoViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 12/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

import Charts

//TODO: Grafico da comparacao dos anos

class PlayerInfoViewController: UIViewController {
    @IBOutlet weak var playerPosterImageView: UIImageView!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var jerseyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var fieldGoalsChartView: PieChartView!
    @IBOutlet weak var threePoitsChartView: PieChartView!
    @IBOutlet weak var freeThrowChartView: PieChartView!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var statsPickerView: UIPickerView!
    
    var player: Player?
    var playerStats: ProfileStats?
    
    var fgMadeDataEntry = PieChartDataEntry(value: 0)
    var fgMissedDataEntry = PieChartDataEntry(value: 1)
    
    var tpMadeDataEntry = PieChartDataEntry(value: 0)
    var tpMissedDataEntry = PieChartDataEntry(value: 1)
    
    var ftMadeDataEntry = PieChartDataEntry(value: 0)
    var ftMissedDataEntry = PieChartDataEntry(value: 1)
    
    var fieldGoalsArray = [PieChartDataEntry]()
    var threePointsArray = [PieChartDataEntry]()
    var freeThrowsArray = [PieChartDataEntry]()
    var barChartArray = [BarChartDataEntry]()
    
    var yearsArrayBarChart = [Years]()
    
    var ppgStat: String = ""
    var rpgStat: String = ""
    var apgStat: String = ""
    var mpgStat: String = ""
    var spgStat: String = ""
    var bpgStat: String = ""
    var dd2Stat: String = ""
    var td3Stat: String = ""
    
    var fgmStat: String = ""
    var fgaStat: String = ""
    var tpmStat: String = ""
    var tpaStat: String = ""
    var ftmStat: String = ""
    var ftaStat: String = ""
    var yValue: Double = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    var statsTitles: [String] = []
    var statsValues: [String] = []
    
    @IBOutlet weak var segControll: UISegmentedControl!
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if segControll.selectedSegmentIndex == 2{
            collectionView.alpha = 0
            barChartView.alpha = 1
            statsPickerView.alpha = 1
            view.bringSubviewToFront(barChartView)
            view.bringSubviewToFront(statsPickerView)
            
            getStats()
            fillBarChartArrays()
            putBarChartStats()
            
        }else{
            getStats()
            putStats()
            statsPickerView.alpha = 0
            view.sendSubviewToBack(barChartView)
            view.sendSubviewToBack(statsPickerView)
            barChartView.alpha = 0
            collectionView.alpha = 1
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
    }
    
    func initData(){
        GetData.shared.getPlayerStats(player: player, vc: self)
        
        statsPickerView.backgroundColor = UIColor.white

        statsTitles = ["Points per game","Rebounds per game","Assists per game","Minutes per game","Steals per game","Blocks per game","Double Doubles","Triple Doubles"]
    }
    
    func fillArrays(){
        
        
        [fieldGoalsChartView, threePoitsChartView, freeThrowChartView].forEach {
            $0?.chartDescription?.text = ""
            $0?.drawEntryLabelsEnabled = false
            $0?.drawHoleEnabled = true
            $0?.legend.enabled = false
            $0?.holeRadiusPercent = 0.15
            $0?.usePercentValuesEnabled = true
            $0?.transparentCircleRadiusPercent = 0.2
            
            
            
        }
        
        fieldGoalsArray = [fgMissedDataEntry, fgMadeDataEntry]
        threePointsArray = [tpMissedDataEntry, tpMadeDataEntry]
        freeThrowsArray = [ftMissedDataEntry, ftMadeDataEntry]
        
    }
    func fillBarChartArrays(){
        barChartArray.removeAll()
        
        yearsArrayBarChart.forEach {
            
            switch statsPickerView.selectedRow(inComponent: 0) {
            case 0:
                yValue = Double($0.total.ppg) ?? 0
                break
            case 1:
                yValue = Double($0.total.rpg) ?? 0
                break
            case 2:
                yValue = Double($0.total.apg) ?? 0
                break
            case 3:
                yValue = Double($0.total.mpg) ?? 0
                break
            case 4:
                yValue = Double($0.total.spg) ?? 0
                break
            case 5:
                yValue = Double($0.total.bpg) ?? 0
                break
            case 6:
                yValue = Double($0.total.dd2) ?? 0
                break
            case 7:
                yValue = Double($0.total.td3) ?? 0
                break
            default:
                yValue = Double($0.total.ppg) ?? 0
            }
            
            barChartArray.append(BarChartDataEntry(x: Double($0.seasonYear), y: yValue))
        }
    }
    
    func putStats() {
        statsValues = [ppgStat, rpgStat, apgStat, mpgStat, spgStat, bpgStat, dd2Stat, td3Stat]
        
        collectionView.reloadData()
        
        fgMadeDataEntry.value = Double(fgmStat) ?? 0
        fgMissedDataEntry.value = (Double(fgaStat) ?? 0) - fgMadeDataEntry.value
        
        tpMadeDataEntry.value = Double(tpmStat) ?? 0
        tpMissedDataEntry.value = (Double(tpaStat) ?? 0) - tpMadeDataEntry.value
        
        ftMadeDataEntry.value = Double(ftmStat) ?? 0
        ftMissedDataEntry.value = (Double(ftaStat) ?? 0) - ftMadeDataEntry.value
        
        updateChart(array: fieldGoalsArray, pieView: fieldGoalsChartView)
        updateChart(array: threePointsArray, pieView: threePoitsChartView)
        updateChart(array: freeThrowsArray, pieView: freeThrowChartView)
        
       
    }
    func putBarChartStats() {
        updateBarChart(array: barChartArray, barChart: barChartView)
    }
    
    func getLatestStats(_ playerStats: ProfileStats) {
        ppgStat = playerStats.latest.ppg
        rpgStat = playerStats.latest.rpg
        apgStat = playerStats.latest.apg
        mpgStat = playerStats.latest.mpg
        spgStat = playerStats.latest.spg
        bpgStat = playerStats.latest.bpg
        dd2Stat = playerStats.latest.dd2
        td3Stat = playerStats.latest.td3
        
        fgmStat = playerStats.latest.fgm
        fgaStat = playerStats.latest.fga
        tpmStat = playerStats.latest.tpm
        tpaStat = playerStats.latest.tpa
        ftmStat = playerStats.latest.ftm
        ftaStat = playerStats.latest.fta
        
        //        print("Get Latest Stats")
    }
    func getAllYearsStats(_ playerStats: ProfileStats) {
        ppgStat = playerStats.regularSeason.season[0].total.ppg
        rpgStat = playerStats.regularSeason.season[0].total.rpg
        apgStat = playerStats.regularSeason.season[0].total.apg
        mpgStat = playerStats.regularSeason.season[0].total.mpg
        spgStat = playerStats.regularSeason.season[0].total.spg
        bpgStat = playerStats.regularSeason.season[0].total.bpg
        dd2Stat = playerStats.regularSeason.season[0].total.dd2
        td3Stat = playerStats.regularSeason.season[0].total.td3
        
        fgmStat = playerStats.regularSeason.season[0].total.fgm
        fgaStat = playerStats.regularSeason.season[0].total.fga
        tpmStat = playerStats.regularSeason.season[0].total.tpm
        tpaStat = playerStats.regularSeason.season[0].total.tpa
        ftmStat = playerStats.regularSeason.season[0].total.ftm
        ftaStat = playerStats.regularSeason.season[0].total.fta
        
        //        print("get All Years Stats")
    }
    func getCareerSummary(_ playerStats: ProfileStats) {
        ppgStat = playerStats.careerSummary.ppg
        rpgStat = playerStats.careerSummary.rpg
        apgStat = playerStats.careerSummary.apg
        mpgStat = playerStats.careerSummary.mpg
        spgStat = playerStats.careerSummary.spg
        bpgStat = playerStats.careerSummary.bpg
        dd2Stat = playerStats.careerSummary.dd2
        td3Stat = playerStats.careerSummary.td3
        
        fgmStat = playerStats.careerSummary.fgm
        fgaStat = playerStats.careerSummary.fga
        tpmStat = playerStats.careerSummary.tpm
        tpaStat = playerStats.careerSummary.tpa
        ftmStat = playerStats.careerSummary.ftm
        ftaStat = playerStats.careerSummary.fta
        
        //        print("Get Career Summary")
    }
    func getYears(_ playerStats: ProfileStats) {
        yearsArrayBarChart = playerStats.regularSeason.season
    }
    
    func getStats(){
        guard let playerStats = GetData.shared.playerStats else {return}
        switch segControll.selectedSegmentIndex {
        case 0:
            getLatestStats(playerStats)
        case 1:
            getCareerSummary(playerStats)
        case 2:
            getYears(playerStats)
        default:
            getLatestStats(playerStats)
        }
    }
    
    func updateChart(array: [PieChartDataEntry], pieView: PieChartView){
        let dataSet = PieChartDataSet(values: array, label: "")
        dataSet.sliceSpace = 5
        let data = PieChartData(dataSet: dataSet)
        data.setValueFont(.systemFont(ofSize: 10, weight: .bold))
        data.setValueTextColor(UIColor.black)
        data.setDrawValues(true)
        
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.multiplier = 1
        pFormatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        let colors = [UIColor.red,UIColor.green]
        dataSet.colors = colors
        
        pieView.data = data
        pieView.animate(yAxisDuration: 2)
        
        //        print("Update Charts")
    }
    func updateBarChart(array: [BarChartDataEntry], barChart: BarChartView) {
        print(array[0])
        let dataSet = BarChartDataSet(values: array, label: "")
        dataSet.formLineWidth = 10
        dataSet.valueFont = NSUIFont(name: "Marker Felt", size: 12 )!
        dataSet.colors = [NSUIColor.black]
        
        let data = BarChartData(dataSet: dataSet)
        let pFormatter = NumberFormatter()
        pFormatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        
        barChart.xAxis.labelCount = array.count
        barChart.data = data
        barChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        barChart.backgroundColor = UIColor.white
        
    }
    
    func putInfo() {
        if let player = player{
            playerNameLabel.text = player.firstName + " " + player.lastName
            teamNameLabel.text = player.teamName
            countryLabel.text = player.country
            jerseyLabel.text = "Jersey: " + player.jersey
            positionLabel.text = "Position: " + player.pos
            heightLabel.text = "Height: " + player.heightMeters + "m"
            weightLabel.text = "Weight: " + player.weightKilograms + "Kg"
            ageLabel.text = "Age: " + getAge(dob: player.dateOfBirthUTC)
            
            self.teamLogoImageView.setImageWithUrl(url: player.teamLogo)
            
            self.playerPosterImageView.setImageWithUrl(url: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/\(player.personId).png")
        }
    }
    
    func getAge(dob: String) -> String{
        /// Format Date
        let myFormatte = DateFormatter()
        myFormatte.dateFormat = "yyyy-MM-dd"
        
        /// Convert DOB to new Date
        let finalDate : Date = myFormatte.date(from: dob)!
        
        /// Todays Date
        let now = Date()
        /// Calender
        let calendar = Calendar.current
        
        /// Get age Components
        let ageComponents = calendar.dateComponents([.year], from: finalDate, to: now)
        
        if let age = ageComponents.year {
            return "\(age) years old"
        }else{
            return "Not Found"
        }
        
        
    }
    
}

extension PlayerInfoViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statsTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statsTitles[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fillBarChartArrays()
        putBarChartStats()
    }
    
}

extension PlayerInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StatsCollectionViewCell
        
        let statTitle = statsTitles[indexPath.item]
        if statsValues.count > 0{
            let statValue = statsValues[indexPath.item]
            cell.statsValueLabel.text = statValue
        }else{
            cell.statsValueLabel.text = ""
        }
        
        
        cell.statsTitleLabel.text = statTitle
        
        
        return cell
    }
}

