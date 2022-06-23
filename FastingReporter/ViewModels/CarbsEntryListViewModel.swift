//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation
import HealthKit

@MainActor class CarbsEntryListViewModel: ObservableObject {
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
        removeAllEntryCarbs()

        healthStore.fetchEntryCarbs { querySamples in
            for sample in querySamples {
                // print("sample:", sample)
                if let hkQuanitySample = sample as? HKQuantitySample {
                    let carb = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                              date: hkQuanitySample.startDate)
                    // print("carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                    Task { @MainActor in
                        self.carbsList.append(carb)
                    }
                }
            }
            // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
            self.sortAllEntryCarbs()        // NOTE: Must sort within the collection closure.
        }
    }

    func sortAllEntryCarbs() {
        Task { @MainActor in
            self.carbsList.sort()
        }
    }

    func removeAllEntryCarbs() {
        Task { @MainActor in
            self.carbsList.removeAll()
        }
    }

    func fetchFirstEntryCarbs() {
        healthStore.fetchFirstEntryCarbs { querySamples in
            for sample in querySamples {
                // print("sample:", sample)
                if let hkQuanitySample = sample as? HKQuantitySample {
                    let carb = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                              date: hkQuanitySample.startDate)
                    print("carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                    Task { @MainActor in
                        // self.carbsList.append(carb)
                        self.carbsFirst = carb
                    }
                }
            }
        }
    }
}
