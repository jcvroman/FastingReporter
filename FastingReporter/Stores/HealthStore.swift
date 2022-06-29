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
    var collectionQuery: HKStatisticsCollectionQuery?
    
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

    func fetchDailyCarbs(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let carbType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        collectionQuery = HKStatisticsCollectionQuery(quantityType: carbType, quantitySamplePredicate: predicate,
                                            options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        collectionQuery?.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore, let query = self.collectionQuery {
            healthStore.execute(query)
        }
    }

    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void) {
    // func fetchEntryCarbs(completion: @escaping ([HKSample]) -> Void) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) else {
            fatalError("*** This method should never fail! ***")
        }
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: HKQueryOptions.strictEndDate)

        var carbsList = [CarbModel]()

        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                       predicate: predicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) {
                (query: HKSampleQuery, querySamples: [HKSample]?, error: Error?) in
            if let querySamples = querySamples {
                for sample in querySamples {
                    if let hkQuanitySample = sample as? HKQuantitySample {
                        let carb = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                             date: hkQuanitySample.startDate)
                        // print("fetchEntryCarbs: carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                        carbsList.append(carb)
                    }
                    completion(carbsList)
                    // completion(querySamples ?? [])
                }
            }
        }
        healthStore?.execute(sampleQuery)
    }

    func fetchFirstEntryCarbs(completion: @escaping ([HKSample]) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: HKQueryOptions.strictEndDate)

        let sampleQuery = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicate,
                                       limit: 1,
                                       sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) {
            // (query, results, error) in
            (query: HKSampleQuery, querySamples: [HKSample]?, error: Error?) in
                completion(querySamples ?? [])
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
