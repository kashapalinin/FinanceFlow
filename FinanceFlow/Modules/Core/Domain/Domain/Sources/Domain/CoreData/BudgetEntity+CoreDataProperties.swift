//
//  BudgetEntity+CoreDataProperties.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
//

public import Foundation
public import CoreData


public typealias BudgetEntityCoreDataPropertiesSet = NSSet

extension BudgetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetEntity> {
        return NSFetchRequest<BudgetEntity>(entityName: "BudgetEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var id: UUID
    @NSManaged public var startDate: Date

}

extension BudgetEntity : Identifiable {

}
