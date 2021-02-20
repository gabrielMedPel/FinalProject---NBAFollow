//
//  UICollectionViewCell+extensions.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 16/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

extension UICollectionViewCell{
    func updateCell(row: Int){
        //if parent is Table View -> {}
        if let collectionView = self.superview as? UICollectionView{
            //tableView -> check to see if updates are pending
            collectionView.reloadItems(at: [IndexPath(item: row, section: 0)])
        }
    }
}
