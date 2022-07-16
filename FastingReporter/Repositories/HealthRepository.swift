//
//  HealthRepository.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/30/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol HealthRepositoryProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void)
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void)
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel]
}

final class HealthRepository: HealthRepositoryProtocol {
    private let healthStore: HealthStoreProtocol

    init(healthStore: HealthStoreProtocol = HealthStore()) {
        self.healthStore = healthStore
    }

    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(completion: completion)
    }

    // NOTE: Async func.
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchEntryCarbs(daysBack: daysBack, limit: limit, completion: completion)
    }

    // NOTE: Async func.
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchDailyCarbs(daysBack: daysBack, completion: completion)
    }

    // MARK: - Business Logic.
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel] {
        var carbsListTemp: [CarbModel] = []
        print("DEBUG: HealthRepository.updateEntryCarbs: carbsList: \(carbsList)")

        // NOTE: Loop thru carbsList & carbsList next element in order to assign next element item to current one.
        for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
            lhs.previousDate = rhs.date

            // NOTE: Get minutes from previous date to date.
            lhs.diffSeconds = Calendar.current
                .dateComponents([.second], from: lhs.previousDate!, to: lhs.date)  // FIXME: Clean up. No force unwrap.
                .second
            carbsListTemp.append(lhs)
            /*
            print("DEBUG: HealthRepository.updateEntryCarbs: carb: \(lhs.carbs);")
            print("    date: \(lhs.date);previous date: \(lhs.previousDate ?? Date());")
            print("    diff minutes: \(lhs.diffSeconds ?? 0); id: \(lhs.id)")
            */
        }
        if let carbsListLast = carbsList.last {
            carbsListTemp.append(carbsListLast)    // NOTE: Append back last element as it was dropped off of loop per.
        }
        return carbsListTemp
    }
}
