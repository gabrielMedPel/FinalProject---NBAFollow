//
//  PKHUD.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 17/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import PKHUD

protocol ShowHUD{}
extension ShowHUD{
    func showProgress(title:String, subtitle: String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title:String, subtitle: String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 3)
    }
    
    func showLabel(title:String){
        HUD.flash(.label(title), delay: 3)
    }
    
    func showSuccess(title:String, subtitle: String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle) ,delay: 3)
    }
}
extension UIViewController: ShowHUD{}
