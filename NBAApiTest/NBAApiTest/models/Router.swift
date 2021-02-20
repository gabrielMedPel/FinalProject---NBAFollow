//
//  Router.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 13/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class Router {
    private init(){}
    
    static var shared = Router()
    
    func openMenu(viewController: UIViewController){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menu")
        viewController.present(vc, animated: true)
    }
}
