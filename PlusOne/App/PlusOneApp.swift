//
//  PlusOneApp.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/06/22.
//

import SwiftUI

@main
struct PlusOneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
