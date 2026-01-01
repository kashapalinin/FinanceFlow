//
//  TransactionEntity+CoreDataClass.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
//

public import Foundation
public import CoreData

public typealias TransactionEntityCoreDataClassSet = NSSet

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
    public func toTransaction() -> Transaction {
        Transaction(id: id, amount: amount, category: category, date: date, note: note, type: TransactionType(rawValue: type) ?? .INCOME)
    }
}
