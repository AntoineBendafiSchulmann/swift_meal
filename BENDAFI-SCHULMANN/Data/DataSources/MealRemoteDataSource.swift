//
//  MealRemoteDataSource.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//


import Foundation

class MealRemoteDataSource {
    func searchMeals(by keyword: String) async throws -> [MealItemDTO] {
        guard !keyword.isEmpty else { return [] }
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(keyword)"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MealSearchDTO.self, from: data)
        return decoded.meals ?? []
    }

    func fetchCategories() async throws -> [String] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(CategoryListDTO.self, from: data)
        return decoded.meals.compactMap { $0.strCategory }
    }
}
