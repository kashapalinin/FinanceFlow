//
//  Budget.swift
//  Domain
//
//  Created by Павел Калинин on 31.12.2025.
//
import Foundation
import CoreData

public struct Budget {
    public let id: UUID
    public let amount: Double
    public let startDate: Date
    
    public init(id: UUID, amount: Double, startDate: Date) {
        self.id = id
        self.amount = amount
        self.startDate = startDate
    }
}

extension Budget {
    public func toBudgetEntity(context: NSManagedObjectContext) -> BudgetEntity {
        let entity =  BudgetEntity(context: context)
        entity.id = self.id
        entity.amount = self.amount
        entity.startDate = self.startDate
        return entity
    }
}
