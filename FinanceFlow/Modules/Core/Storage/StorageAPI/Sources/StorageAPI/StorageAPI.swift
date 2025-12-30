// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreData

public protocol StorageService {
    func get<T>() -> T 
}

public protocol IUserDefaultsStorage {
    func get<T: Codable>(forKey key: String) -> T?
    func save<T: Codable>(_ value: T?, forKey key: String)
    func delete(_ key: String)
    func hasValue(forKey key: String) -> Bool
}

public protocol ICoreDataManager {
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
}
