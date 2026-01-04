//
//  CategoryEntity+CoreDataProperties.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 04.01.2026.
//
//

public import Foundation
public import CoreData


public typealias CategoryEntityCoreDataPropertiesSet = NSSet

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var color: Data
    @NSManaged public var icon: Data
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: Int16

}

extension CategoryEntity : Identifiable {

}
