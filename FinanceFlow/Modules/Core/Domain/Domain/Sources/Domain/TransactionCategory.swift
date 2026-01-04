//
//  Category.swift
//  Domain
//
//  Created by Павел Калинин on 01.01.2026.
//
import Foundation
import CoreData

public struct TransactionCategory {
    public let id: UUID
    public let name: String
    public let type: TransactionType
    public let icon: Data
    public let color: Data
    
    
    public init(id: UUID, name: String, type: TransactionType, icon: Data, color: Data) {
        self.id = id
        self.name = name
        self.type = type
        self.icon = icon
        self.color = color
    }
}

extension TransactionCategory {
    public func toCategoryEntity(context: NSManagedObjectContext) -> CategoryEntity {
        let entity = CategoryEntity(context: context)
        entity.id = id
        entity.name = name
        entity.type = type.rawValue
        entity.icon = icon
        entity.color = color
        return entity
    }
}
