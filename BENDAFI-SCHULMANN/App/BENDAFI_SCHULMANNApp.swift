//
//  BENDAFI_SCHULMANNApp.swift
//  BENDAFI-SCHULMANN
//
//  Created by AntoineBendafi on 10/01/2025.
//

import SwiftUI

@main
struct BENDAFI_SCHULMANNApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
