//
//  GroceryItem+CoreDataProperties.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation
import CoreData

extension GroceryItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroceryItem> {
        NSFetchRequest<GroceryItem>(entityName: "GroceryItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var isChecked: Bool
}

extension GroceryItem: Identifiable {}
