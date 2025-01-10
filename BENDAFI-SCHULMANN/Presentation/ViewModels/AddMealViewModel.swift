//
//  AddMealViewModel.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

@MainActor
class AddMealViewModel: ObservableObject {
    @Published var title = ""
    @Published var category = ""
    @Published var area = ""
    @Published var instructions = ""
    @Published var imageURL = ""
    @Published var categoryList: [String] = []

    @Published var ingredientName = "Sample"
    @Published var ingredientQty = "1"

    private let interactor: MealInteractor

    init(interactor: MealInteractor) {
        self.interactor = interactor
        Task {
            let cats = await interactor.loadCategories()
            categoryList = cats
        }
    }

    func createMeal() {
        let ingData = [(name: ingredientName,
                        qty: Double(ingredientQty) ?? 1.0,
                        unit: "unit")]

        let meal = interactor.createMeal(
            title: title,
            category: category,
            area: area,
            instructions: instructions,
            imageURL: imageURL.isEmpty ? nil : imageURL,
            ingredientsData: ingData
        )
        interactor.togglePlanned(meal)
    }
}
