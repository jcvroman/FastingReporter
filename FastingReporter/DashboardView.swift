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

    @ObservedObject var carbsEntryListVM: CarbsEntryListViewModel
    @ObservedObject var carbsDailyListVM: CarbsDailyListViewModel

    init() {
        // healthStore = HealthStore()
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
        .onAppear(perform: fetchHealthStore)
    }

    // MARK: - Sub Views.
    private var carbsEntryListView: some View {
        List(carbsEntryListVM.carbsList) { carb in
            HStack {
                Text("\(carb.carbs)")
                Spacer()
                Text(carb.date, style: .date)
                Spacer()
                Text(carb.date, style: .time)
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
                Text(carb.date, style: .date)
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

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
