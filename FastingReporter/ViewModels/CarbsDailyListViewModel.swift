//
//  CarbsDailyListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

final class CarbsDailyListViewModel: ObservableObject {
    var healthStore: HealthStore
    @Published private(set) var carbsList: [CarbModel] = []

    init(healthStore: HealthStore) {
        self.healthStore = healthStore
    }

    func fetchDailyCarbs() {
        healthStore.fetchDailyCarbs() { hCarbsList in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                self.carbsList = hCarbsList
                self.sortAllDailyCarbs()        // NOTE: Must sort within the collection closure.
            }
        }
    }

    func sortAllDailyCarbs() {
        // self.carbsList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        self.carbsList.sort()
    }
}
