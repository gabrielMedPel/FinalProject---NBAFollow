//
//  NewsTableViewCell.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 18/01/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var articleImageVies: UIImageView!
    

    func populate(with article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description ?? ""
        self.authorLabel.text = "by \(article.author ?? "no author")"
        
        let date = article.publishedAt
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        self.publishedAtLabel.text = "published at \(dateFormatter.string(from: date))"
        
        self.articleImageVies.setImageWithUrl(url: article.urlToImage ?? "")
    }
    
}
