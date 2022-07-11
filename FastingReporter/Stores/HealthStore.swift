//
//  HealthStore.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/26/21.
//

import Foundation
import HealthKit
import UIKit

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol HealthStoreProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void)
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void)
    func fetchEntryCarbsFirst(completion: @escaping (CarbModel) -> Void)
}

// NOTE: Default Protocols: Implement it in extension, but can override it by implementing it again in struct, class...

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
        // FIXME: Use error.
        healthStore.requestAuthorization(toShare: [], read: [carbType]) { (success, error) in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void) {
        let carbType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let now = Date()
        let currentDateStartOfDay = Calendar.current.startOfDay(for: now)
        // print("DEBUG: HealthStore.fetchDailyCarbs: currentDateStartOfDay: \(currentDateStartOfDay)")
        let startDate = Calendar.current.date(byAdding: .day, value: daysBack, to: currentDateStartOfDay)
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        // print("DEBUG: HealthStore.fetchDailyCarbs: startDate: \(String(describing: startDate))")

        var carbsList = [CarbModel]()

        collectionQuery = HKStatisticsCollectionQuery(quantityType: carbType, quantitySamplePredicate: predicate,
                                                      options: .cumulativeSum, anchorDate: anchorDate,
                                                      intervalComponents: daily)
        collectionQuery?.initialResultsHandler = { query, statisticsCollection, error in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            if let statisticsCollection = statisticsCollection {
                print("statisticsCollection:", statisticsCollection)
                let startDate = Calendar.current.date(byAdding: .day, value: daysBack, to: currentDateStartOfDay)!
                let endDate = now
                statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                    let gram = statistics.sumQuantity()?.doubleValue(for: .gram())
                    let carb = CarbModel(carbs: Int(gram ?? 0), date: statistics.startDate)
                    // print("carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                    carbsList.append(carb)
                }
                DispatchQueue.main.async {
                    completion(carbsList)
                }
            }
        }

        if let healthStore = healthStore, let query = self.collectionQuery {
            healthStore.execute(query)
        }
    }

    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)
        else {
            fatalError("*** This method should never fail! ***")
        }
        // print("DEBUG: HealthStore.fetchEntryCarbs: limit: \(limit)")

        let now = Date()
        let currentDateStartOfDay = Calendar.current.startOfDay(for: now)
        // print("DEBUG: HealthStore.fetchEntryCarbs: currentDateStartOfDay: \(currentDateStartOfDay)")
        let startDate = Calendar.current.date(byAdding: .day, value: daysBack, to: currentDateStartOfDay)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now,
                                                    options: HKQueryOptions.strictEndDate)
        // print("DEBUG: HealthStore.fetchEntryCarbs: startDate: \(String(describing: startDate))")

        var carbsList = [CarbModel]()

        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit,
                          sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)])
        { (query: HKSampleQuery, querySamples: [HKSample]?, error: Error?) in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            if let querySamples = querySamples {
                for sample in querySamples {
                    if let hkQuanitySample = sample as? HKQuantitySample {
                        let carb = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                             date: hkQuanitySample.startDate)
                        // print("DEBUG: HealthStore.fetchEntryCarbs: carb: \(carb.carbs); date: \(carb.date)")
                        carbsList.append(carb)
                    }
                    DispatchQueue.main.async {
                        completion(carbsList)
                    }
                }
            }
        }
        healthStore?.execute(sampleQuery)
    }

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch 1st entry carb via
    //       fetchEntryCarbs.
    func fetchEntryCarbsFirst(completion: @escaping (CarbModel) -> Void) {
        let defaultDaysBack = -10

        var carbsList = [CarbModel]()
        var carbsFirst = CarbModel(carbs: 0, date: Date())

        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async { [weak self] in
            print("DEBUG: HealthStore.fetchEntryCarbsFirst: Completed")
            self?.fetchEntryCarbs(daysBack: defaultDaysBack, limit: 1) { hCarbsList in
                carbsList = hCarbsList
                print("DEBUG: HealthStore.fetchEntryCarbsFirst: carbsList: \(carbsList)")
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async {
            // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("DEBUG: HealthStore.fetchEntryCarbsFirst: Completed")
                carbsFirst = carbsList.first ?? carbsFirst
                print("DEBUG: HealthStore.fetchEntryCarbsFirst: carbsFirst: \(String(describing: carbsFirst))")

                completion(carbsFirst)
                semaphore.signal()
            }
            semaphore.wait()
        }
        print("DEBUG: HealthStore.fetchEntryCarbsFirst: Starting...")
    }
}

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(
            from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
