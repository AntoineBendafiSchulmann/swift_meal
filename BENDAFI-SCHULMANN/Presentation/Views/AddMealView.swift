//
//  AddMealView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

struct AddMealView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddMealViewModel

    init(vm: AddMealViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    TextField("Title", text: $vm.title)
                    Picker("Category", selection: $vm.category) {
                        Text("None").tag("")
                        ForEach(vm.categoryList, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    TextField("Area", text: $vm.area)
                }
                Section("Instructions") {
                    TextEditor(text: $vm.instructions)
                        .frame(height: 120)
                }
                Section("Image") {
                    TextField("Image URL", text: $vm.imageURL)
                }
            }
            .navigationTitle("Create Meal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        vm.createMeal()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
