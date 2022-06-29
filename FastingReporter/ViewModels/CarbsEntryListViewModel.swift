//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation
import HealthKit

class CarbsEntryListViewModel: ObservableObject {
    var healthStore: HealthStore
    @Published private(set) var carbsList: [CarbModel] = []
    @Published private(set) var carbsFirst: CarbModel?

    // init() {
    init(healthStore: HealthStore) {
        // healthStore = HealthStore()
        self.healthStore = healthStore
    }

    // func fetchEntryCarbs(_ querySamples: [HKSample]) {
    func fetchEntryCarbs() {
        // removeAllEntryCarbs()            // NOTE: REMOVE: Do not need to remove all now from previous refresh?

        healthStore.fetchEntryCarbs() { hCarbsList in
            self.carbsList = hCarbsList
            
            // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
            self.sortAllEntryCarbs()        // NOTE: Must sort within the collection closure.
            self.updateAllEntryCarbs()
        }
    }

    func sortAllEntryCarbs() {
        // Task { @MainActor in
            self.carbsList.sort()
        // }
    }
    
    // FIXME: BUG: carbsList is most often empty here. Most likely because of the MainActor stuff timing? Yep!
    //        FIX: Removed MainActor and Task stuff. Now warning about publishing changes from background threads.
    //        TODO: Make publishing changes from main thread.
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
            print("updateAllEntryCarbs: carb: \(lhs.carbs); date: \(lhs.date);previous date: \(lhs.previousDate ?? Date());")
            print("    diff minutes: \(lhs.diffMinutes ?? 0); id: \(lhs.id)")
        }
        carbsList2.append(carbsList.last!)       // NOTE: Append back last element.
        // Task { @MainActor in
            self.carbsList = carbsList2
        // }
    }

    func removeAllEntryCarbs() {
        // Task { @MainActor in
            self.carbsList.removeAll()
        // }
    }

    func fetchFirstEntryCarbs() {
        healthStore.fetchFirstEntryCarbs() { hCarbsFirst in
            self.carbsFirst = hCarbsFirst
        }
    }
}
