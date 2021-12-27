//
//  Extension+NSManagedObject.swift
//  CoreDataPractice
//
//  Created by Yang Siyeon on 2021/12/23.
//

import Foundation
import CoreData

public protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
}

extension NSManagedObject: Managed { }
public extension Managed where Self: NSManagedObject {
    static var entityName: String { return String(describing: self) }

    static var fetchRequest: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}
