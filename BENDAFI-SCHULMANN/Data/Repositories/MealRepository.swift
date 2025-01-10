//
//  MealRepository.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation
import CoreData

class MealRepository {
    private let context: NSManagedObjectContext
    private let remoteDS: MealRemoteDataSource

    init(context: NSManagedObjectContext, remoteDS: MealRemoteDataSource) {
        self.context = context
        self.remoteDS = remoteDS
    }

    func loadCategories() async throws -> [String] {
        try await remoteDS.fetchCategories()
    }

    private func parseIngredients(from dto: MealItemDTO) -> [(name: String, qty: Double, unit: String?)] {
        var result: [(String, Double, String?)] = []

        let ingredientsPairs = [
            (dto.strIngredient1, dto.strMeasure1),
            (dto.strIngredient2, dto.strMeasure2),
            (dto.strIngredient3, dto.strMeasure3),
            (dto.strIngredient4, dto.strMeasure4),
            (dto.strIngredient5, dto.strMeasure5),
            (dto.strIngredient6, dto.strMeasure6),
            (dto.strIngredient7, dto.strMeasure7),
            (dto.strIngredient8, dto.strMeasure8),
            (dto.strIngredient9, dto.strMeasure9),
            (dto.strIngredient10, dto.strMeasure10),
            (dto.strIngredient11, dto.strMeasure11),
            (dto.strIngredient12, dto.strMeasure12),
            (dto.strIngredient13, dto.strMeasure13),
            (dto.strIngredient14, dto.strMeasure14),
            (dto.strIngredient15, dto.strMeasure15),
            (dto.strIngredient16, dto.strMeasure16),
            (dto.strIngredient17, dto.strMeasure17),
            (dto.strIngredient18, dto.strMeasure18),
            (dto.strIngredient19, dto.strMeasure19),
            (dto.strIngredient20, dto.strMeasure20)
        ]

        for (ingNameOpt, measureOpt) in ingredientsPairs {
            if let ingName = ingNameOpt, !ingName.isEmpty {
                let measure = measureOpt ?? "1"
                let qty: Double = 1.0
                let unit: String? = measure

                result.append((ingName, qty, unit))
            }
        }

        return result
    }

    func searchMealsByKeyword(_ keyword: String) async throws -> [Meal] {
        let dtos = try await remoteDS.searchMeals(by: keyword)
        var results: [Meal] = []

        for dto in dtos {
            let meal = Meal(context: context)
            meal.id = UUID()
            meal.title = dto.strMeal
            meal.category = dto.strCategory
            meal.area = dto.strArea
            meal.instructions = dto.strInstructions
            meal.imageURL = dto.strMealThumb
            meal.isPlanned = false
            meal.isTasted = false

            let ingData = parseIngredients(from: dto)

            let ingSet = ingData.map { info -> Ingredient in
                let ing = Ingredient(context: context)
                ing.id = UUID()
                ing.name = info.name
                ing.quantity = info.qty
                ing.unit = info.unit
                ing.meal = meal
                return ing
            }
            meal.ingredients = NSSet(array: ingSet)

            results.append(meal)
        }
        try? context.save()
        return results
    }

    func createMeal(
        title: String,
        category: String,
        area: String,
        instructions: String,
        imageURL: String?,
        ingredientsData: [(name: String, qty: Double, unit: String?)]
    ) -> Meal {
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.title = title
        meal.category = category
        meal.area = area
        meal.instructions = instructions
        meal.imageURL = imageURL
        meal.isPlanned = false
        meal.isTasted = false

        let ingSet = ingredientsData.map { info -> Ingredient in
            let ing = Ingredient(context: context)
            ing.id = UUID()
            ing.name = info.name
            ing.quantity = info.qty
            ing.unit = info.unit
            ing.meal = meal
            return ing
        }
        meal.ingredients = NSSet(array: ingSet)

        try? context.save()
        return meal
    }


    func togglePlanned(_ meal: Meal) {
        meal.isPlanned.toggle()
        try? context.save()
    }

    func fetchPlannedMeals() -> [Meal] {
        let request = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "isPlanned == true")
        return (try? context.fetch(request)) ?? []
    }

    func updateGroceries() {
        let plannedMeals = fetchPlannedMeals()
        let existingItems = fetchGroceries()

        var map: [String: GroceryItem] = [:]
        for g in existingItems {
            if let key = g.name?.lowercased() {
                map[key] = g
            }
        }

        for meal in plannedMeals {
            if let ingSet = meal.ingredients as? Set<Ingredient> {
                for ing in ingSet {
                    let key = (ing.name ?? "").lowercased()
                    if let existing = map[key] {
                        existing.quantity += ing.quantity
                    } else {
                        let newG = GroceryItem(context: context)
                        newG.id = UUID()
                        newG.name = key
                        newG.quantity = ing.quantity
                        newG.unit = ing.unit
                        newG.isChecked = false
                        map[key] = newG
                    }
                }
            }
        }
        try? context.save()
    }

    func fetchGroceries() -> [GroceryItem] {
        let req = GroceryItem.fetchRequest()
        return (try? context.fetch(req)) ?? []
    }

    func toggleChecked(_ grocery: GroceryItem) {
        grocery.isChecked.toggle()
        try? context.save()
    }
}
