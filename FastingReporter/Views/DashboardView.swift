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
                    .fill(Color.secondary.opacity(0.9))
                    .cornerRadius(10.0)
                    .frame(minHeight: 90, idealHeight: 90, maxHeight: 90, alignment: .center)
                    .shadow(color: Color.blue.opacity(0.9), radius: 10, x: 10, y: 10)
                    .padding(20)
            }
            VStack {
                Text("Fasting:")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.primary)
                + Text(" \(currentFastVM.carbsFirst?.date ?? Date(), style: .timer)")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.red)
            }
            .shadow(color: Color.primary.opacity(0.6), radius: 5, x: 5, y: 10)
        }
    }

    private var carbsEntryListView: some View {
        List(carbsEntryListVM.carbsList) { carb in
            HStack {
                Text("\(carb.carbs)")
                Spacer()
                // Text(carb.date, style: .date)
                Text(carb.date, formatter: dateShortFormatter)
                Spacer()
                // Text(carb.date, style: .time)
                Text(carb.date, formatter: timeShortFormatter)
                Spacer()
                // FIXME: BUG: Display nothing here if previous date nil. I.e. provide defaults at an earlier stage in
                //        the process.
                Text(carb.previousDate ?? Date(), formatter: timeShortFormatter)
                Spacer()
                // FIXME: BUG: Display nothing here if diff minutes nil. I.e. provide defaults at an earlier stage in
                //        the process.
                Text("\(carb.diffMinutes ?? 0)")
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

// FIXME: TODO: Verify that best to have date formatters available globally?
// FIXME: TODO: The formatting of the date should be in the view model?
private let dateShortFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    // logger.debug("MyListsItem: itemFormatter")
    print("DEBUG: MyListsItem: itemFormatter")
    return formatter
}()

// FIXME: TODO: The formatting of the date should be in the view model?
private let timeShortFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    // logger.debug("MyListsItem: itemFormatter")
    print("DEBUG: MyListsItem: itemFormatter")
    return formatter
}()

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
