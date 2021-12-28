//
//  Article+CoreDataClass.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/23.
//
//

import Foundation
import CoreData

@objc(Article)
final class Article: NSManagedObject, Identifiable {
    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var viewCount: Int64
    @NSManaged public var category: Category?
    @NSManaged public var categoryName: String?
}

extension Article {
    static func listAllFetchRequest() -> NSFetchRequest<Article> {
        let fetchRequest = Article.fetchRequest

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Article.name), ascending: false)]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.propertiesToFetch = [
            #keyPath(Article.name),
            #keyPath(Article.categoryName),
            #keyPath(Article.viewCount)
        ]

        return fetchRequest
    }
}
