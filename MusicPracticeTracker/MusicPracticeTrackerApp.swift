//
//  MusicPracticeTrackerApp.swift
//  MusicPracticeTracker
//a
//  Created by ALLEN LIU on 10/26/26.
//

import SwiftUI
import SwiftData

@main
struct MusicPracticeTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //for data persistence
        .modelContainer(for: SessionsData.self)
    }
}
