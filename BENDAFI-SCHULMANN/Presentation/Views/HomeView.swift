//
//  HomeView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @State private var showAddMeal = false

    init(vm: HomeViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                categoryChips
                content
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddMeal) {
            let addVM = AddMealViewModel(interactor: vm.interactor)
            AddMealView(vm: addVM)
        }
        .onAppear {
            vm.loadIfNeeded()
        }
    }

    private var searchBar: some View {
        TextField("Search a meal...", text: $vm.searchText)
            .textFieldStyle(.roundedBorder)
            .padding()
            .onSubmit {
                vm.searchMeals()
            }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.categories, id: \.self) { cat in
                    Button {
                        vm.toggleCategory(cat)
                    } label: {
                        Text(cat)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                vm.selectedCategories.contains(cat)
                                ? Color.green
                                : Color.gray.opacity(0.2)
                            )
                            .cornerRadius(12)
                            .foregroundColor(
                                vm.selectedCategories.contains(cat)
                                ? .white
                                : .black
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 4)
    }

    private var content: some View {
        Group {
            if vm.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                        .font(.footnote)
                }
                .padding()
            } else if vm.searchText.isEmpty && vm.meals.isEmpty {
                Text("Enter a keyword above.")
                    .foregroundColor(.secondary)
                    .padding()
            } else if vm.meals.isEmpty {
                Text("No results for '\(vm.searchText)'.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                mealList
            }
        }
    }

    private var mealList: some View {
        List(vm.meals, id: \.objectID) { meal in
            NavigationLink {
                MealDetailView(meal: meal, interactor: vm.interactor)
            } label: {
                HStack(spacing: 12) {
                    if let urlString = meal.imageURL,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .failure(_):
                                Color.gray
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Color.gray
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(meal.title ?? "")
                            .font(.headline)
                        if let cat = meal.category, let area = meal.area {
                            Text("\(cat) • \(area)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()

                    if meal.isPlanned {
                        Image(systemName: "calendar.badge.minus")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
