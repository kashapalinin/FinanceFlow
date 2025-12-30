//
//  CoreDataManager.swift
//  StorageImpl
//
//  Created by Павел Калинин on 30.12.2025.
//
import StorageAPI
import CoreData

final class CoreDataManager: ICoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "FinanceFlow")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        try? viewContext.save()
    }
}
