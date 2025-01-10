//
//  ContentView.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
