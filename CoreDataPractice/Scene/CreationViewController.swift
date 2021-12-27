//
//  CreationViewController.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/23.
//

import UIKit
import CoreData

class CreationViewController: UIViewController {
    
    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var isCategoryType: Bool = true {
        didSet {
            selectCategoryView.isHidden = isCategoryType
        }
    }
    
    private var selectedCategory: Category?
    
    private let categoriesFetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest = Category.listAllFetchRequest()
        
        return NSFetchedResultsController<Category>(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCategoryType = categorySwitch.isOn
        
        fetchCategories()
        
        print(categoriesFetchedResultsController.fetchedObjects)
    }
    
    private func fetchCategories() {
        do {
            try categoriesFetchedResultsController.performFetch()
        } catch {
            print("Categories fetch error \(error)")
        }
    }
    
    private func addNewCategory(name: String) {
        let category = Category(context: PersistentContainer.shared.viewContext)
        category.name = name
        
        do {
            try PersistentContainer.shared.viewContext.save()
        } catch {
            PersistentContainer.shared.viewContext.delete(category)
            print("Save category error : \(error.localizedDescription)")
        }
    }
    
    private func addNewArticle(name: String, category: Category) {
        let article = Article(context: PersistentContainer.shared.viewContext)
        article.name = name
        article.category = category
        
        do {
            try PersistentContainer.shared.viewContext.save()
        } catch {
            PersistentContainer.shared.viewContext.delete(article)
            print("Save article error : \(error.localizedDescription)")
        }
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        guard let sender = sender as? UISwitch else { return }
        self.isCategoryType = sender.isOn
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let title = titleTextField.text else {
            print("Please enter a title")
            return
        }
        if isCategoryType {
            addNewCategory(name: title)
        } else {
            guard let selectedCategory = selectedCategory else {
                print("Please select a category")
                return
            }
            addNewArticle(name: title, category: selectedCategory)
        }
    }
}
