//
//  HealthStore.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/26/21.
//

import Foundation
import HealthKit

class HealthStore {
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let carbType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        guard let healthStore = self.healthStore else { return completion(false) }
        healthStore.requestAuthorization(toShare: [], read: [carbType]) { (success, error) in
            completion(success)
        }
    }

    func calculateCarbs(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let carbType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        query = HKStatisticsCollectionQuery(quantityType: carbType, quantitySamplePredicate: predicate,
                                            options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        query?.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
}

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(
            from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
