//
//  HealthStore.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/26/21.
//

import Foundation
import HealthKit
import UIKit

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol HealthStoreProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void)
    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void)
    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void)
}

// NOTE: Default Protocols: Implement it in extension, but can still override it by implementing it again in the struct, class.

final class HealthStore: HealthStoreProtocol {
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
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void) {
        let carbType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let currentDateStartOfDay = Calendar.current.startOfDay(for: Date())
        // print("DEBUG: Date: \(currentDateStartOfDay)")
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDateStartOfDay)
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        // print("DEBUG: HealthStore.fetchDailyCarbs: startDate: \(String(describing: startDate))")
        
        var carbsList = [CarbModel]()

        collectionQuery = HKStatisticsCollectionQuery(quantityType: carbType, quantitySamplePredicate: predicate,
                                                      options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        collectionQuery?.initialResultsHandler = { query, statisticsCollection, error in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                if let statisticsCollection = statisticsCollection {
                    print("statisticsCollection:", statisticsCollection)
                    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                    let endDate = Date()
                    statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                        let gram = statistics.sumQuantity()?.doubleValue(for: .gram())
                        let carb = CarbModel(carbs: Int(gram ?? 0), date: statistics.startDate)
                        // print("carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                        carbsList.append(carb)
                    }
                    completion(carbsList)
                }
            }
        }

        if let healthStore = healthStore, let query = self.collectionQuery {
            healthStore.execute(query)
        }
    }

    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void) {
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
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                if let querySamples = querySamples {
                    for sample in querySamples {
                        if let hkQuanitySample = sample as? HKQuantitySample {
                            let carb = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                                 date: hkQuanitySample.startDate)
                            print("DEBUG: HealthStore.fetchEntryCarbs: carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                            carbsList.append(carb)
                        }
                        completion(carbsList)
                    }
                }
            }
        }
        healthStore?.execute(sampleQuery)
    }

    // TODO: FIX: REMOVE: Roll this functionality into fetchEntryCarbs.
    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) else {
            fatalError("*** This method should never fail! ***")
        }
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: HKQueryOptions.strictEndDate)

        var carbsFirst = CarbModel(carbs: 0, date: Date())

        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                       predicate: predicate,
                                       limit: 1,
                                       sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) {
                (query: HKSampleQuery, querySamples: [HKSample]?, error: Error?) in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                if let querySamples = querySamples {
                    for sample in querySamples {
                        if let hkQuanitySample = sample as? HKQuantitySample {
                            carbsFirst = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                                 date: hkQuanitySample.startDate)
                            // print("fetchFirstEntryCarbs: carbsFirst: \(carbsFirst.carbs); date: \(carbsFirst.date); id: \(carbsFirst.id)")
                        }
                        completion(carbsFirst)
                    }
                }
            }
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
