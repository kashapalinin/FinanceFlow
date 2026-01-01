//
//  Transaction.swift
//  Domain
//
//  Created by Павел Калинин on 31.12.2025.
//
import Foundation
import CoreData

public enum TransactionType: Int16 {
    case EXPENSE = 0, INCOME = 1
}

public struct Transaction {
    public var id: UUID
    public var amount: Double
    public var category: String
    public var date: Date
    public var note: String?
    public var type: TransactionType
}

extension Transaction {
    public func toTransactionEntity(context: NSManagedObjectContext) -> TransactionEntity {
        let entity = TransactionEntity(context: context)
        entity.id = id
        entity.amount = amount
        entity.category = category
        entity.date = date
        entity.note = note
        entity.type = type.rawValue
        return entity
    }
}
