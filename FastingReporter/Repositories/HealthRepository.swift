//
//  HealthRepository.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/30/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol HealthRepositoryProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void)
    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void)
    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void)
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel]
}

final class HealthRepository: HealthRepositoryProtocol {
    private let healthStore: HealthStoreProtocol

    init(healthStore: HealthStoreProtocol = HealthStore()) {
        self.healthStore = healthStore
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(completion: completion)
    }

    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void) {
        healthStore.fetchFirstEntryCarbs(completion: completion)
    }

    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchEntryCarbs(completion: completion)
    }

    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchDailyCarbs(completion: completion)
    }

    // MARK: - Business Logic.
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel] {
        var carbsListTemp: [CarbModel] = []
        print("DEBUG: HealthRepository.updateEntryCarbs: carbsList: \(carbsList)")
        
        // NOTE: Loop thru carbsList and carbsList next element in order to assign next element item to current element item.
        for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
            lhs.previousDate = rhs.date
            // FIX: TODO: Clean up. No force unwrap.
            lhs.diffMinutes = Calendar.current
                .dateComponents([.minute], from: lhs.previousDate!, to: lhs.date)
                .minute
            carbsListTemp.append(lhs)
            /*
            print("DEBUG: HealthRepository.updateEntryCarbs: carb: \(lhs.carbs);")
            print("    date: \(lhs.date);previous date: \(lhs.previousDate ?? Date());")
            print("    diff minutes: \(lhs.diffMinutes ?? 0); id: \(lhs.id)")
            */
        }
        if let carbsListLast = carbsList.last {
            carbsListTemp.append(carbsListLast)       // NOTE: Append back last element as it was dropped off of loop per zip.
        }
        return carbsListTemp
    }
}
