//
//  MealPlanViewModel.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

@MainActor
class MealPlanViewModel: ObservableObject {
    @Published var planned: [Meal] = []
    let interactor: MealInteractor

    init(interactor: MealInteractor) {
        self.interactor = interactor
    }

    func loadPlanned() {
        planned = interactor.fetchPlannedMeals()
    }

    func togglePlanned(_ meal: Meal) {
        interactor.togglePlanned(meal)
        loadPlanned()
    }
}
