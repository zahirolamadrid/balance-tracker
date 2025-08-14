//
//  BalanceTrackerApp.swift
//  BalanceTracker
//
//  Created by Zahiro on 8/14/25.
//

import SwiftUI

@main
struct BalanceTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
