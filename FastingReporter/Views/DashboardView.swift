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
            fastListMainView
            carbsEntryListMainView
            carbsDailyListMainView
        }
        .onChange(of: scenePhase) { newPhase in         // NOTE: Fetch on change to/back to app.
            if newPhase == .active {
                // print("DEBUG: DashboardView.body: Active")
                fetchHealthRepository()
            }
        }
    }

    // MARK: - Sub Views.
    // MARK: - Current Fast Views.
    private var currentFastView: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.secondary.opacity(0.1))
                    .cornerRadius(10.0)
                    .frame(minHeight: 90, idealHeight: 90, maxHeight: 90, alignment: .center)
                    .shadow(color: Color.accentColor.opacity(1.0), radius: 10, x: 10, y: 10)
                    .padding(20)
            }
            VStack {
                Text("Fast: ")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.primary)
                + Text("\(currentFastVM.carbsFirst?.date ?? Date(), style: .timer)")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.secondary)
            }
        }
        .shadow(color: Color.accentColor.opacity(1.0), radius: 5, x: 5, y: 5)
        .overlay(aboutButton, alignment: .topTrailing)
        .alert(item: $currentFastVM.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }

    // MARK: - Fast List Views.
    private var fastListMainView: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                fastListView
                    .refreshable() { fetchUpdateEntryCarbs() }
            } else {
                // NOTE: Fallback on earlier versions.
                fastListView
            }

            if carbsEntryListVM.isLoading { LoadingView() }
        }
        .overlay(fastListHeader, alignment: .topLeading)
    }

    private var fastListView: some View {
        List(carbsEntryListVM.fastList) { carb in
            CarbFastRowView(carb: carb)
        }
    }

    private var fastListHeader: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Date")
                .frame(minWidth: 190, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            Spacer(minLength: 10)
            Text("Fast")
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
        }
        .font(.system(size: 18).lowercaseSmallCaps())       // NOTE: Use set size so no resizing per System Settings.
        .shadow(color: Color.accentColor.opacity(1.0), radius: 5, x: 5, y: 5)
    }

    // MARK: - Carbs Entry List Views.
    private var carbsEntryListMainView: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                carbsEntryListView
                    .refreshable() { fetchUpdateEntryCarbs() }
            } else {
                // NOTE: Fallback on earlier versions.
                carbsEntryListView
            }

            if carbsEntryListVM.isLoading { LoadingView() }
        }
        .overlay(carbsEntryListHeader, alignment: .topLeading)
    }

    private var carbsEntryListView: some View {
        List(carbsEntryListVM.carbsListCVM) { carb in
            CarbEntryRowView(carb: carb)
        }
    }

    private var carbsEntryListHeader: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Date")
                .frame(minWidth: 190, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            Text("Carbs")
                .frame(minWidth: 30, alignment: .leading)
            Spacer(minLength: 10)
            Text("Fast")
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
        }
        .font(.system(size: 18).lowercaseSmallCaps())
        .shadow(color: Color.accentColor.opacity(1.0), radius: 5, x: 5, y: 5)
    }

    // MARK: - Carbs Daily List Views.
    private var carbsDailyListMainView: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                carbsDailyListView
                    .refreshable() { fetchDailyCarbs() }
            } else {
                // NOTE: Fallback on earlier versions.
                carbsDailyListView
            }

            if carbsDailyListVM.isLoading { LoadingView() }
        }
        .overlay(carbsDailyListHeader, alignment: .topLeading)
     }

    private var carbsDailyListView: some View {
        List(carbsDailyListVM.carbsListCVM) { carb in
            CarbDailyRowView(carb: carb)
        }
     }

    private var carbsDailyListHeader: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Date")
                .frame(minWidth: 190, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            Text("Carbs")
                .frame(minWidth: 30, alignment: .leading)
        }
        .font(.system(size: 18).lowercaseSmallCaps())
        .shadow(color: Color.accentColor.opacity(1.0), radius: 5, x: 5, y: 5)
    }

    // MARK: - Buttons.
    private var aboutButton: some View {
        Button(action: showAbout, label: {
            Image(systemName: "info.circle")
                .font(.title)
                .padding([.top, .trailing], 5)
                .shadow(color: Color.accentColor.opacity(1.0), radius: 5, x: 5, y: 5)
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

    private func fetchUpdateEntryCarbs() {
        carbsEntryListVM.requestAuthorization { success in
            if success {
                carbsEntryListVM.fetchUpdateEntryCarbs()
            }
        }
    }

    private func fetchDailyCarbs() {
        carbsEntryListVM.requestAuthorization { success in
            if success {
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
