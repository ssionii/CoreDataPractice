//
//  Category+CoreDataClass.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/23.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Identifiable {
    @NSManaged public var articleCount: Int64
    @NSManaged public var name: String?
    @NSManaged public var viewCount: Int64
    @NSManaged public var articles: NSSet?
}

extension Category {
    static func listAllFetchRequest() -> NSFetchRequest<Category> {
        let fetchRequest = Category.fetchRequest
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: false)]
        fetchRequest.propertiesToFetch = [
            #keyPath(Category.name)
        ]
        
        return fetchRequest
    }
}
