//
//  MealInteractor.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//


import Foundation

class MealInteractor {
    private let repo: MealRepository

    init(repo: MealRepository) {
        self.repo = repo
    }

    func loadCategories() async -> [String] {
        do {
            return try await repo.loadCategories()
        } catch {
            return []
        }
    }

    func createMeal(
        title: String,
        category: String,
        area: String,
        instructions: String,
        imageURL: String?,
        ingredientsData: [(name: String, qty: Double, unit: String?)]
    ) -> Meal {
        repo.createMeal(
            title: title,
            category: category,
            area: area,
            instructions: instructions,
            imageURL: imageURL,
            ingredientsData: ingredientsData
        )
    }

    func searchMeals(keyword: String) async -> [Meal] {
        do {
            return try await repo.searchMealsByKeyword(keyword)
        } catch {
            return []
        }
    }

    func togglePlanned(_ meal: Meal) {
        repo.togglePlanned(meal)
        repo.updateGroceries()
    }

    func fetchPlannedMeals() -> [Meal] {
        repo.fetchPlannedMeals()
    }

    func updateGroceries() {
        repo.updateGroceries()
    }

    func fetchGroceries() -> [GroceryItem] {
        repo.fetchGroceries()
    }

    func toggleChecked(_ item: GroceryItem) {
        repo.toggleChecked(item)
    }
}
