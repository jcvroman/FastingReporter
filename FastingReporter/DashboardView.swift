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
    private var healthStore = HealthStore()
    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject var carbsEntryListVM: CarbsEntryListViewModel
    @ObservedObject var carbsDailyListVM: CarbsDailyListViewModel

    init() {
        carbsEntryListVM = CarbsEntryListViewModel(healthStore: healthStore)
        carbsDailyListVM = CarbsDailyListViewModel(healthStore: healthStore)
    }

    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 0) {
                    Color.clear
                }
                VStack {
                    Text("Current Fast:")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    Text("\(carbsEntryListVM.carbsFirst?.date ?? Date(), style: .timer)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                }
            }
            carbsEntryListView
            carbsDailyListView
        }
        // NOTE: Re-fetch on change back to app.
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("DEBUG: Active")
                fetchHealthStore()
            }
        }
    }

    // MARK: - Sub Views.
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
                // FIXME: BUG: Display nothing here if previous date nil.
                Text(carb.previousDate ?? Date(), formatter: timeShortFormatter)
            }
            .accessibility(identifier: "carbsEntryListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Entry List")
    }

    private var carbsDailyListView: some View {
        List(carbsDailyListVM.carbsList) { carb in
            HStack(alignment: .center) {
                Text("\(carb.carbs)")
                Spacer()
                // Text(carb.date, style: .date)
                Text(carb.date, formatter: dateShortFormatter)
                Spacer()
            }
            .accessibility(identifier: "carbsDailyListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Daily List")
     }

    // MARK: - Actions.
    private func fetchHealthStore() {
        // if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    carbsEntryListVM.fetchFirstEntryCarbs()
                    carbsEntryListVM.fetchEntryCarbs()
                    carbsDailyListVM.fetchDailyCarbs()
                }
            }
        // }
    }
}

// MARK: - Others.

// FIXME: TODO: Verify that best to have date formatters available globally?
// FIXME: TODO: The formatting of the date should be in the view model?
private let dateShortFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    // logger.debug("MyListsItem: itemFormatter")
    print("MyListsItem: itemFormatter")
    return formatter
}()

// FIXME: TODO: The formatting of the date should be in the view model?
private let timeShortFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    // logger.debug("MyListsItem: itemFormatter")
    print("MyListsItem: itemFormatter")
    return formatter
}()


// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
