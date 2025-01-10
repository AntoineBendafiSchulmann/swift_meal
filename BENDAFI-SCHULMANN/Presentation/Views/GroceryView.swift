//
//  GroceryView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct GroceryView: View {
    @StateObject var vm: GroceryViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.items, id: \.objectID) { item in
                    HStack {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                vm.toggleCheck(item)
                            }
                        Text(item.name ?? "")
                        Spacer()
                        Text("\(item.quantity, specifier: "%.1f") \(item.unit ?? "")")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Groceries")
        }
        .onAppear {
            vm.loadGroceries()
        }
    }
}
