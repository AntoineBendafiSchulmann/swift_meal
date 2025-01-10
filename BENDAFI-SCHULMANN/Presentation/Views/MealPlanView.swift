//
//  MealPlanView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct MealPlanView: View {
    @StateObject var vm: MealPlanViewModel

    var body: some View {
        NavigationView {
            if vm.planned.isEmpty {
                Text("No planned meals.")
                    .foregroundColor(.secondary)
                    .navigationTitle("Meal Plan")
            } else {
                List {
                    ForEach(vm.planned, id: \.objectID) { meal in
                        NavigationLink(destination: {
                            MealDetailView(meal: meal, interactor: vm.interactor)
                        }) {
                            Text(meal.title ?? "")
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                vm.togglePlanned(meal)
                            } label: {
                                Label("Unplan", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Meal Plan")
            }
        }
        .onAppear {
            vm.loadPlanned()
        }
    }
}
