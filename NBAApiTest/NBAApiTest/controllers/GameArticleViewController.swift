//
//  GameArticleViewController.swift
//  NBAApiTest
//
//  Created by Gabriel Pelegrino on 01/02/2021.
//  Copyright © 2021 Gabriel Pelegrino. All rights reserved.
//

import UIKit

class GameArticleViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var vStack: UIStackView!
    
    var gameArticle: NBAGameArticleResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        putArticle()
    }
    
    func putArticle() {
        
        guard let gameArticle = gameArticle else {return}
        
        titleLabel.text = gameArticle.title
        authorLabel.text = gameArticle.author
        authorTitleLabel.text = gameArticle.authorTitle
        copyRightLabel.text = gameArticle.copyright
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        guard let date = gameArticle.pubDateUTC else {return}
        publishedAtLabel.text = "published at: \(formatter.string(from: date))"
        
        
    
      
        
        gameArticle.paragraphs.forEach {
            let label = UILabel()
            label.text = $0.paragraph
            label.font = UIFont(name: "Arial", size: 16)
            label.numberOfLines = 0
            vStack.addArrangedSubview(label)
        }
    }

}
