//
//  ArticleCell.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/28.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    func configure(category: String?, title: String?, viewCount: String?) {
        categoryLabel.text = category
        titleLabel.text = title
        viewCountLabel.text = viewCount
    }
}
