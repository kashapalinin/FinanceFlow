//
//  CoreDataManager.swift
//  StorageImpl
//
//  Created by Павел Калинин on 30.12.2025.
//
import StorageAPI
import CoreData

final public class CoreDataManager: ICoreDataManager {
    private let persistentContainer: NSPersistentContainer
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init() {
        persistentContainer = NSPersistentContainer(name: "FinanceFlow")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func saveContext() {
        guard viewContext.hasChanges else { return }
        try? viewContext.save()
    }
}
