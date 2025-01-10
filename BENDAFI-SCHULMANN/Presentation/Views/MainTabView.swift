//
//  MainTabView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) var context

    var body: some View {
        TabView {
            let homeRepo = MealRepository(context: context,
                                          remoteDS: MealRemoteDataSource())
            let homeInteractor = MealInteractor(repo: homeRepo)
            HomeView(vm: HomeViewModel(interactor: homeInteractor))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            let planRepo = MealRepository(context: context,
                                          remoteDS: MealRemoteDataSource())
            let planInteractor = MealInteractor(repo: planRepo)
            MealPlanView(vm: MealPlanViewModel(interactor: planInteractor))
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Meal Plan")
                }

            let groceryRepo = MealRepository(context: context,
                                             remoteDS: MealRemoteDataSource())
            let groceryInteractor = MealInteractor(repo: groceryRepo)
            GroceryView(vm: GroceryViewModel(interactor: groceryInteractor))
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
        }
    }
}
