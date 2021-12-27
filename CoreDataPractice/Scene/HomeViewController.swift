//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/21.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView) { tableView, indexPath, articleObjectID in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        
        guard let article = try? PersistentContainer.shared.viewContext.existingObject(with: articleObjectID) as? Article else { return cell }
        cell.textLabel?.text = article.category?.name
        cell.detailTextLabel?.text = article.name
        return cell
    }
    
    private let articlesFetchedResultsController: NSFetchedResultsController<Article> = {
        let fetchRequest = Article.listAllFetchRequest()
        
        return NSFetchedResultsController<Article>(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getObjectByNSFetchRequest()
        
        articlesFetchedResultsController.delegate = self
        
        fetchArticles()
        
        tableView.dataSource = dataSource
    }
    
    private func fetchArticles() {
        do {
            try articlesFetchedResultsController.performFetch()
        } catch {
            print("Articles fetch error \(error)")
        }
    }
    
    // MARK: - 예제
    private func getObjectByObjectID() {
        // object ID 가져오기
        let category = Category(context: PersistentContainer.shared.viewContext)
        let categoryObjectID = category.objectID
        
        // NSManagedObjectContext에서 ID로 object 가져오기
        do {
            let object = try PersistentContainer.shared.viewContext.existingObject(with: categoryObjectID)
            print("object : \(object)")
        } catch {
            print("exisitngObject error \(error.localizedDescription)")
        }
    }
    
    private func getObjectByNSFetchRequest() {
        // 최대 1개의 결과를 가져오도록 request 설정
        let fetchRequest = Category.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        // NSManagedObjectContext에서 fetchRequest로 object 가져오기
        do {
            let object = try PersistentContainer.shared.viewContext.fetch(fetchRequest)
            print("object: \(object)")
        } catch {
            print("fetch error \(error.localizedDescription)")
        }
    }
    
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
    ) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: true)
    }
}
