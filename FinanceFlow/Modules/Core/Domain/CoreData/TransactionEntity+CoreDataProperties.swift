//
//  TransactionEntity+CoreDataProperties.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
//

public import Foundation
public import CoreData


public typealias TransactionEntityCoreDataPropertiesSet = NSSet

extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var type: Int16

}

extension TransactionEntity : Identifiable {

}
