//
//  HealthStore.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/26/21.
//

import Foundation
import HealthKit
import UIKit

class HealthStore {
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var sampleQuery: HKSampleQuery?

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
    
    func calculateCurrentFast(completion: @escaping ([HKSample]) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: HKQueryOptions.strictEndDate)
        
        let sampleQuery = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) {
            // (query, results, error) in
            (query: HKSampleQuery, querySamples: [HKSample]?, error: Error?) in
                completion(querySamples ?? [])

            /*
            print("calculateCurrentFast:", results as Any)
            print("calculateCurrentFast: 1st:", results?.first?.value as Any)
            if let result = results?.first as? HKQuantitySample {
                print("Carbs: quantity: \(result.quantity) | count: \(result.count) | sampleType: \(result.sampleType)")
                print("Carbs: quantityType: \(result.quantityType) | startDate: \(result.startDate) | endDate: \(result.endDate)")
                print("Carbs: uuid: \(result.uuid)")
            }
            */
        }
        healthStore?.execute(sampleQuery)
    }
}

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(
            from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
