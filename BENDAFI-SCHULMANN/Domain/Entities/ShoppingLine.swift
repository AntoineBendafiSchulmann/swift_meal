//
//  GroceryLine.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation

struct ShoppingLine: Identifiable {
    let id: UUID
    let name: String
    let quantity: Double
    let unit: String
    var isChecked: Bool
}
