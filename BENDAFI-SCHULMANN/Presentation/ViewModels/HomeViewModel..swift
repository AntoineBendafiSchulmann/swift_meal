//
//  HomeViewModel..swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var categories: [String] = []
    @Published var selectedCategories: Set<String> = []

    let interactor: MealInteractor

    init(interactor: MealInteractor) {
        self.interactor = interactor
        Task {
            let cats = await interactor.loadCategories()
            categories = cats
        }
    }

    func loadIfNeeded() {
        if !searchText.isEmpty && meals.isEmpty {
            searchMeals()
        }
    }

    func searchMeals() {
        Task {
            guard !searchText.isEmpty else {
                meals = []
                return
            }
            isLoading = true
            var found = await interactor.searchMeals(keyword: searchText)
            if !selectedCategories.isEmpty {
                found = found.filter { meal in
                    guard let cat = meal.category else { return false }
                    return selectedCategories.contains(cat)
                }
            }
            meals = found
            isLoading = false
        }
    }

    func toggleCategory(_ cat: String) {
        if selectedCategories.contains(cat) {
            selectedCategories.remove(cat)
        } else {
            selectedCategories.insert(cat)
        }
        searchMeals()
    }

    func togglePlanned(_ meal: Meal) {
        interactor.togglePlanned(meal)
        objectWillChange.send()
    }
}
