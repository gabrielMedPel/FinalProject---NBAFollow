//
//  SplashViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 21/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit
import Pastel
import Stellar


class SplashViewController: UIViewController {
    @IBOutlet weak var ballView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
        GetData.shared.allPlayers()
        GetData.shared.getStandings()
    }
    
    func setAnimation() {
        setGradientBackground()
        performSegueWithTimeInterval()
        
        ballView.center.x = 0 - ballView.frame.width / 2
        ballView.center.y = 0 - ballView.frame.height / 2
        
        textLabel.center.y = view.center.y
        textLabel.center.x = 0 - textLabel.frame.width
        //        ballView.transform = .identity
        
        ballView.moveY(view.center.y).duration(5).easing(.bounceOut).animate()
        ballView.moveX(view.bounds.width - 5).duration(5).animate()
        textLabel.moveX(view.center.x + textLabel.frame.width).duration(1).delay(4).animate()
        textLabel.makeAlpha(1).duration(1).delay(4).animate()
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    func setGradientBackground() {
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomRight
        pastelView.endPastelPoint = .topLeft
        
        // Custom Duration
        pastelView.animationDuration = 8.0
        
        // Custom Color
        pastelView.setColors([UIColor(hex: "#d10000ff")!,
                              UIColor(hex: "#0054d1ff")!])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    func performSegueWithTimeInterval() {
        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    
}
