//
//  BookMySlot_InterviewerApp.swift
//  BookMySlot_Interviewer
//
//  Created by admin on 15/02/25.
//

import SwiftUI

@main
struct BookMySlot_InterviewerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
