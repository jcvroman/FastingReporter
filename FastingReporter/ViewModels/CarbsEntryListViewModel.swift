//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

class CarbsEntryListViewModel: ObservableObject {
    var healthStore: HealthStore
    @Published private(set) var carbsList: [CarbModel] = []
    @Published private(set) var carbsFirst: CarbModel?

    init(healthStore: HealthStore) {
        self.healthStore = healthStore
    }

    func fetchEntryCarbs() {
        healthStore.fetchEntryCarbs() { hCarbsList in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                self.carbsList = hCarbsList

                // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
                self.sortAllEntryCarbs()        // NOTE: Must sort within the collection closure.
                self.updateAllEntryCarbs()
            }
        }
    }

    func sortAllEntryCarbs() {
        self.carbsList.sort()
    }

    func updateAllEntryCarbs() {
        var carbsList2: [CarbModel] = []
        // print("updateAllEntryCarbs: carbsList: \(carbsList)")
        for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
            lhs.previousDate = rhs.date
            // FIX: TODO: Clean up. No force unwrap.
            lhs.diffMinutes = Calendar.current
                .dateComponents([.minute], from: lhs.previousDate!, to: lhs.date)
                .minute
            carbsList2.append(lhs)
            // print("updateAllEntryCarbs: carb: \(lhs.carbs); date: \(lhs.date);previous date: \(lhs.previousDate ?? Date());")
            // print("    diff minutes: \(lhs.diffMinutes ?? 0); id: \(lhs.id)")
        }
        carbsList2.append(carbsList.last!)       // NOTE: Append back last element.
        self.carbsList = carbsList2
    }

    func fetchFirstEntryCarbs() {
        healthStore.fetchFirstEntryCarbs() { hCarbsFirst in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                self.carbsFirst = hCarbsFirst
            }
        }
    }
}
