//
//  BudgetEntity+CoreDataClass.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
//

public import Foundation
public import CoreData

public typealias BudgetEntityCoreDataClassSet = NSSet

@objc(BudgetEntity)
public class BudgetEntity: NSManagedObject {
    public func toBudget() -> Budget {
        return Budget(id: self.id, amount: self.amount, startDate: self.startDate)
    }
}
