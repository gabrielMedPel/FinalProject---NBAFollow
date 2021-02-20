//
//  UITableViewCell+extensions.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 16/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

extension UITableViewCell{
    func updateCell(){
        //if parent is Table View -> {}
        if let tableView = self.superview as? UITableView{
            //tableView -> check to see if updates are pending
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
