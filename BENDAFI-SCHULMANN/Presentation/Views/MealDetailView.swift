//
//  MealDetailView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    let interactor: MealInteractor
    
    var body: some View {
        ScrollView {
            if let urlString = meal.imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 200)
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure(_):
                        Color.gray.frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray.frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(meal.title ?? "Sans titre")
                    .font(.title)
                
                if let cat = meal.category, !cat.isEmpty {
                    Text("Catégorie : \(cat)")
                        .font(.subheadline)
                }
                if let area = meal.area, !area.isEmpty {
                    Text("Origine : \(area)")
                        .font(.subheadline)
                }
                if let instructions = meal.instructions, !instructions.isEmpty {
                    Text(instructions)
                        .padding(.top, 6)
                }
            }
            .padding()
        }
        .navigationTitle(meal.title ?? "Détails")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    interactor.togglePlanned(meal)
                } label: {
                    Image(systemName: meal.isPlanned ? "calendar.badge.minus" : "calendar.badge.plus")
                }
            }
        }
    }
}
