//
//  UIImageView+extensions.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 16/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView{
    func setImageWithUrl(url: String) {
        guard let url = URL(string: url) else {return}
        
        self.sd_setImage(with: url) { (image, error, cacheTyoe, url) in
            if let error = error{
                print(error)
            }
        }
    }
    func setImageWithUrl(url: String, cell: UITableViewCell, placeholder: UIImage?) {
        guard let url = URL(string: url) else {return}
        
        self.sd_setImage(with: url, placeholderImage: placeholder, completed: { (image, error, cacheType, url) in
            if let error = error{
                print(error)
            }else{
                cell.updateCell()
            }
        })
        
    }
    
    func setImageWithUrl(url: String, cell: UICollectionViewCell, row: Int) {
        guard let url = URL(string: url) else {return}
        
        self.sd_setImage(with: url) { (image, error, cache, url) in
            if let error = error{
                print(error)
            }else{
                cell.updateCell(row: row)
            }
        }
    }
    
}
