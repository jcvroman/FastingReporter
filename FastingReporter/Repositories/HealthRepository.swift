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
}
