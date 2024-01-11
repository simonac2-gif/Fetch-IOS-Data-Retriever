//
//  Fetch_IOS_SampleApp.swift
//  Fetch IOS Sample
//
//  Created by Simon Cooper on 1/10/24.
//

import SwiftUI

@main
struct Fetch_IOS_SampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
