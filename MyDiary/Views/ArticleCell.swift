//
//  ArticleCell.swift
//  MyDiary
//
//  Created by Ruslan NAUMENKO on 1/25/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import rnaumenk2019

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var articleCreationDateLabel: UILabel!
    @IBOutlet weak var articleModificationDate: UILabel!
    
    var article: Article? {
        didSet {
            articleNameLabel.text = article?.title
            
            articleContentLabel.text = article?.content
            
            if let imageData = article?.image as Data? {
                articleImageView.image = UIImage(data: imageData)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = NSLocalizedString("EEEE, MMMM dd, yyyy 'at' h:mm:ss a", comment: "Set in code")
            
            if let creationDate = article?.creationDate as Date?,
                let modificationDate = article?.modificationDate as Date? {
                
                let creationString = dateFormatter.string(from: creationDate)
                let modificationString = dateFormatter.string(from: modificationDate)
                
                articleCreationDateLabel.text = "\(NSLocalizedString("Creation:", comment: "Set in code")) \(creationString)"
                
                guard modificationString != creationString else {
                    articleModificationDate.isHidden = true
                    return
                }
                articleModificationDate.isHidden = false
                articleModificationDate.text = "\(NSLocalizedString("Modification:", comment: "Set in code")) \(modificationString)"
            }
            
        }
    }
    
}
