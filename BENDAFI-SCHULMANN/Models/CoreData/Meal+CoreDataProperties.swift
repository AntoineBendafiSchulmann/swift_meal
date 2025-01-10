//
//  Meal+CoreDataProperties.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation
import CoreData

extension Meal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var category: String?
    @NSManaged public var area: String?
    @NSManaged public var instructions: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var isPlanned: Bool
    @NSManaged public var isTasted: Bool
    @NSManaged public var ingredients: NSSet?
}

extension Meal: Identifiable {}
