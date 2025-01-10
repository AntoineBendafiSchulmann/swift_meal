//
//  CategoryListDTO.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import Foundation

struct CategoryListDTO: Decodable {
    let meals: [CategoryDTO]
}

struct CategoryDTO: Decodable {
    let strCategory: String?
}
