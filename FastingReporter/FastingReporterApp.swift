//
//  FastingReporterApp.swift
//  FastingReporter
//
//  Copyright © 2022 Jimmy Vroman. All rights reserved.
// 
//  Created by Jimmy Vroman on 6/6/21.
//

// NOTE: SwiftUI = Declarative UI; vs UIKit = Programmatic UI & UIKit/Storyboards = Programmatic/Visual Layouts UI.

import SwiftUI

@main
struct FastingReporterApp: App {
    var body: some Scene {
        WindowGroup {
             DashboardView(currentFastVM: CurrentFastViewModel(),
                           carbsEntryListVM: CarbsEntryListViewModel(),
                           carbsDailyListVM: CarbsDailyListViewModel())
        }
    }
}
