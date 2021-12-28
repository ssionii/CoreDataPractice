//
//  DetailViewController.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewCount()
        
        categoryNameLabel.text = article?.category?.name
        titleLabel.text = article?.name
        
        if let creationDate = article?.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            let dateString = dateFormatter.string(from: creationDate)
            creationDateLabel.text = dateString
        } else {
            creationDateLabel.text = ""
        }
        
        if let viewCount = article?.viewCount {
            viewCountLabel.text = String(viewCount)
        } else {
            viewCountLabel.text = "0"
        }
    }
    
    private func updateViewCount() {
        do {
            guard let article = article else { return }
            article.viewCount = article.viewCount + 1
            
            try PersistentContainer.shared.viewContext.save()
        } catch {
            print("Update article error : \(error.localizedDescription)")
        }
    }
}
