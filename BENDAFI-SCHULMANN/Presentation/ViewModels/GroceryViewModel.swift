//
//  GroceryViewModel.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//


import SwiftUI
import CoreData

@MainActor
class GroceryViewModel: ObservableObject {
    @Published var items: [GroceryItem] = []
    private let interactor: MealInteractor
    
    init(interactor: MealInteractor) {
        self.interactor = interactor
    }
    
    func loadGroceries() {
        interactor.updateGroceries()
        items = interactor.fetchGroceries()
    }

    func toggleCheck(_ item: GroceryItem) {
        interactor.toggleChecked(item)
        items = interactor.fetchGroceries()
    }
}
