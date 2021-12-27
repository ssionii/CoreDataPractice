//
//  PersistentContainer.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/23.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {
    
    static let shared: PersistentContainer = {
        // TODO: name + managedObjectModel로 생성하면 어떻게 되는지 확인해보기 (testing?)
        let container = PersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
