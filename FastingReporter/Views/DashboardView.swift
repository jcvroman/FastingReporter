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
            currentFastView
            // currentFastView(currentFastVM: currentFastVM)
            // currentFastView(carbsFirst: currentFastVM.carbsFirst)
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
    }

    private var carbsEntryListView: some View {
        List(carbsEntryListVM.carbsListCVM) { carb in
            HStack {
                Text("\(carb.carbs)")
                Spacer()
                Text(carb.dateDateStr)
                Spacer()
                Text(carb.dateTimeStr)
                Spacer()
                Text(carb.previousDateTimeStr)
                Spacer()
                Text("\(carb.diffMinutes)")
            }
            .accessibility(identifier: "carbsEntryListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Entry List")
    }

    private var carbsDailyListView: some View {
        List(carbsDailyListVM.carbsListCVM) { carb in
            HStack(alignment: .center) {
                Text("\(carb.carbs)")
                Spacer()
                Text(carb.dateDateStr)
                Spacer()
                Text(carb.dateTimeStr)
            }
            .accessibility(identifier: "carbsDailyListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Daily List")
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
        // selectedSheet = .aboutView
        print("DEBUG: DashboardView: showAbout: button tapped")
    }
}

// MARK: - Others.
/*
struct currentFastView: View {
    // var carbsFirst: CarbModel
    var currentFastVM: CurrentFastViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.clear
            }
            VStack {
                Text("Current Fast:")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                Text("\(currentFastVM.carbsFirst?.date ?? Date(), style: .timer)")
                // Text("\(carbsFirst.date, style: .timer)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
            }
        }
    }
}
*/

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
