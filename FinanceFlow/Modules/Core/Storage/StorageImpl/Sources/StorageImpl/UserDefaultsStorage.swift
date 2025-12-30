//
//  UserDefaultsStorage.swift
//  StorageImpl
//
//  Created by Павел Калинин on 26.12.2025.
//
import Foundation
import StorageAPI

public class UserDefaultsStorage: IUserDefaultsStorage {
    private let userDefaults = UserDefaults.standard
    
    public init() {}
    
    public func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("Failed to load \(key): \(error)")
            return nil
        }
    }
    
    public func save<T: Codable>(_ value: T?, forKey key: String) {
        if let value = value {
            do {
                let data = try JSONEncoder().encode(value)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Failed to save \(key): \(error)")
                userDefaults.removeObject(forKey: key)
            }
        } else {
            userDefaults.removeObject(forKey: key)
        }
    }
    
    public func delete(_ key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func hasValue(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}
