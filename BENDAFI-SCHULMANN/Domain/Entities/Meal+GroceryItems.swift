//
//  Meal+CoreDataProperties.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation

extension Meal {
    var groceryItems: [ShoppingLine] {
        guard let ingSet = ingredients as? Set<Ingredient> else {
            return []
        }
        return ingSet.map { ing in
            ShoppingLine(
                id: UUID(),
                name: ing.name ?? "",
                quantity: ing.quantity,
                unit: ing.unit ?? "",
                isChecked: false
            )
        }
    }
}
