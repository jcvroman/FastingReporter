//
//  CarbsDailyListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

@MainActor class CarbsDailyListViewModel: ObservableObject {
    var healthStore: HealthStore
    @Published private(set) var carbsList: [CarbModel] = []

    // init() {
    init(healthStore: HealthStore) {
        // healthStore = HealthStore()
        self.healthStore = healthStore
    }
    
    // func fetchDailyCarbs(_ statisticsCollection: HKStatisticsCollection) {
    func fetchDailyCarbs() {
        // if let healthStore = healthStore {
            // healthStore.requestAuthorization { success in
                // if success {
                    healthStore.fetchDailyCarbs { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            print("statisticsCollection:", statisticsCollection)
                            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                            let endDate = Date()
                            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                                let gram = statistics.sumQuantity()?.doubleValue(for: .gram())
                                let carb = CarbModel(carbs: Int(gram ?? 0), date: statistics.startDate)
                                print("carb: \(carb.carbs); date: \(carb.date); id: \(carb.id)")
                                Task { @MainActor in
                                    self.carbsList.append(carb)
                                }
                            }
                            Task { @MainActor in
                                self.carbsList.sort()
                            }
                        }
                    }
                // }
            // }
        // }
    }
}
