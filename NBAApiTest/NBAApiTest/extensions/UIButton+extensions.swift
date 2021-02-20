//
//  UIButton+extensions.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 16/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit
import SDWebImage

extension UIButton{
    func setImageWithUrl(url: String) {
        guard let url = URL(string: url) else {return}
        
        self.sd_setImage(with: url, for: .normal) { (image, error, cahce, url) in
            if error != nil{
                print(error!)
            }
        }
    }
    func setImageWithUrl(url: String, cell: UICollectionViewCell, row: Int) {
        guard let url = URL(string: url) else {return}
        
        self.sd_setImage(with: url, for: .normal) { (image, error, cahce, url) in
            if let error = error{
                print(error)
            }else{
                cell.updateCell(row: row)
            }
        }
        
    }
}
