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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }

        guard let article = try? PersistentContainer.shared.viewContext.existingObject(with: articleObjectID) as? Article else { return cell }
        cell.configure(
            category: article.category?.name,
            title: article.name,
            viewCount: String(article.viewCount)
        )
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

        articlesFetchedResultsController.delegate = self
        
        fetchArticles()
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func fetchArticles() {
        do {
            try articlesFetchedResultsController.performFetch()
        } catch {
            print("Articles fetch error \(error)")
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailVC.article = articlesFetchedResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
