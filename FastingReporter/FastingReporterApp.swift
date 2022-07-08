//
//  FastingReporterApp.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/6/21.
//

// NOTE: SwiftUI = Declarative UI; vs UIKit = Programmatic UI & UIKit/Storyboards = Programmatic/Visual Layouts UI.

import SwiftUI

@main
struct FastingReporterApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}
