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
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
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
        
        categoriesFetchedResultsController.delegate = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        isCategoryType = categorySwitch.isOn
       
        fetchCategories()
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
        article.creationDate = Date()
        
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
        navigationController?.popViewController(animated: true)
    }
}

extension CreationViewController: UIPickerViewDelegate {
    
}

extension CreationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesFetchedResultsController.object(at: IndexPath(row: row, section: 0)).name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoriesFetchedResultsController.object(at: IndexPath(row: row, section: 0))
    }
}

extension CreationViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            categoryPickerView.reloadComponent(indexPath?.row ?? 0)
        }
    }
}
