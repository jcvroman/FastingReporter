//
//  DashboardView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/6/21.
//

import HealthKit
import SwiftUI

struct DashboardView: View {
    // NOTE: Think of main/root views as a table of contents (i.e. not too little or too much here).
    @Environment(\.scenePhase) private var scenePhase

    // NOTE: These objects are created in App and passed in here.
    // NOTE: Use ObservedObject when an object is created elsewhere.
    // NOTE: Use @StateObject where you create an object.
    @ObservedObject var currentFastVM: CurrentFastViewModel
    @ObservedObject var fastListVM: FastListViewModel
    @ObservedObject var carbsEntryListVM: CarbsEntryListViewModel
    @ObservedObject var carbsDailyListVM: CarbsDailyListViewModel

    var body: some View {
        NavigationView {
            VStack {
                // TODO: Display of empty lists.
                CurrentFastView(currentFastVM: currentFastVM)
                FastListView(fastListVM: fastListVM)
                CarbsEntryListView(carbsEntryListVM: carbsEntryListVM)
                CarbsDailyListView(carbsDailyListVM: carbsDailyListVM)
            }
            .onChange(of: scenePhase) { newPhase in         // NOTE: Fetch on change to/back to app.
                if newPhase == .active {
                    // print("DEBUG: DashboardView.body: Active")
                    fetchHealthRepository()
                }
            }
            .navigationTitle("\(Constants.appName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarView)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Sub Views.
    // MARK: - Others.
    private func toolbarView() -> some View {
        HStack {
                aboutButton
                helpButton
        }
    }

    // MARK: - Buttons.
    private var aboutButton: some View {
        Button(action: {
            showAbout()
        }) {
            Label("About", systemImage: "info.circle")
                .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        }
    }

    private var helpButton: some View {
        Button(action: {
            showHelp()
        }) {
            Label("Help", systemImage: "questionmark.circle")
                .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        }
    }

    // MARK: - Actions.
    private func fetchHealthRepository() {
        currentFastVM.requestAuthorization { success in
            if success {
                currentFastVM.fetchEntryCarbsFirst()
                carbsEntryListVM.fetchEntryCarbs()
                fastListVM.fetchFastList()
                carbsDailyListVM.fetchDailyCarbs()
            }
        }
    }

    private func showAbout() {
        currentFastVM.showAbout()
        // print("DEBUG: DashboardView: showAbout: button tapped")
    }

    private func showHelp() {
        currentFastVM.showHelp()
        // print("DEBUG: DashboardView: showHelp: button tapped")
    }
}

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(currentFastVM: CurrentFastViewModel(),
                      fastListVM: FastListViewModel(),
                      carbsEntryListVM: CarbsEntryListViewModel(),
                      carbsDailyListVM: CarbsDailyListViewModel())
    }
}
