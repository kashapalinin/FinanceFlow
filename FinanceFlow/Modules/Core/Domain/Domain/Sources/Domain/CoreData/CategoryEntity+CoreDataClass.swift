//
//  CategoryEntity+CoreDataClass.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 04.01.2026.
//
//

public import Foundation
public import CoreData

public typealias CategoryEntityCoreDataClassSet = NSSet

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject {
    public func toCategory() -> TransactionCategory {
        TransactionCategory(id: id, name: name, type: TransactionType(rawValue: type) ?? .INCOME, icon: icon, color: color)
    }
}
