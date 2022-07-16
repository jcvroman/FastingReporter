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

    // NOTE: Use @StateObject when you create an object.
    @StateObject private var currentFastVM = CurrentFastViewModel()
    @StateObject private var carbsEntryListVM = CarbsEntryListViewModel()
    @StateObject private var carbsDailyListVM = CarbsDailyListViewModel()

    var body: some View {
        VStack {
            // TODO: Handle empty lists.
            currentFastView
            carbsEntryListView
            carbsDailyListView
        }
        .onChange(of: scenePhase) { newPhase in         // NOTE: Fetch on change to/back to app.
            if newPhase == .active {
                // print("DEBUG: DashboardView.body: Active")
                fetchHealthRepository()
            }
        }
    }

    // MARK: - Sub Views.
    private var currentFastView: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.secondary.opacity(0.1))
                    .cornerRadius(10.0)
                    .frame(minHeight: 90, idealHeight: 90, maxHeight: 90, alignment: .center)
                    .shadow(color: Color.accentColor.opacity(0.9), radius: 10, x: 10, y: 10)
                    .padding(20)
            }
            VStack {
                Text("Fast: ")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.primary)
                + Text("\(currentFastVM.carbsFirst?.date ?? Date(), style: .timer)")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.red)
            }
            .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        }
        .overlay(aboutButton, alignment: .topTrailing)
        .alert(item: $currentFastVM.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }

    private var carbsEntryListView: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                entryListView
                // TODO: Verify warning not an issue for refreshable.
                //      WARNING: Converting non-sendable function value to '@Sendable () async -> Void' may introduce
                //               data races
                .refreshable(action: fetchHealthRepository)
            } else {
                // NOTE: Fallback on earlier versions.
                entryListView
            }

            if carbsEntryListVM.isLoading { LoadingView() }
        }
    }

    private var entryListView: some View {
        List(carbsEntryListVM.carbsListCVM) { carb in
            HStack {
                Text("\(carb.carbs)")
                    .padding(15)
                VStack(alignment: .leading) {
                    Text(carb.dateDateStr)
                    Text(carb.dateTimeStr)
                }
                Spacer(minLength: 10)
                Text("\(carb.diffHoursMinutesStr)")
            }
            .accessibility(identifier: "carbsEntryListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Entry List")
    }

    private var carbsDailyListView: some View {
        ZStack {
            List(carbsDailyListVM.carbsListCVM) { carb in
                HStack(alignment: .center) {
                    Text("\(carb.carbs)")
                        .padding(10)
                    Text(carb.dateDateStr)
                }
                .accessibility(identifier: "carbsDailyListLabel")
                .font(.body)
            }
            .navigationTitle("Carbs Daily List")

            if carbsDailyListVM.isLoading { LoadingView() }
        }
     }

    // MARK: - Buttons.
    private var aboutButton: some View {
        Button(action: showAbout, label: {
            Image(systemName: "info.circle")
                .font(.title)
                .padding([.top, .trailing], 5)
                .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        })
    }

    // MARK: - Actions.
    private func fetchHealthRepository() {
        currentFastVM.requestAuthorization { success in
            if success {
                currentFastVM.fetchEntryCarbsFirst()
                carbsEntryListVM.fetchUpdateEntryCarbs()
                carbsDailyListVM.fetchDailyCarbs()
            }
        }
    }

    private func showAbout() {
        currentFastVM.showAbout()
        // print("DEBUG: DashboardView: showAbout: button tapped")
    }
}

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
