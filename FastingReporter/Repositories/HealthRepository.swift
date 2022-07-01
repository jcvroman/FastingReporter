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
    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void)
    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void)
    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void)
}

final class HealthRepository: HealthRepositoryProtocol {
    private let healthStore: HealthStoreProtocol

    init(healthStore: HealthStoreProtocol = HealthStore()) {
        self.healthStore = healthStore
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(completion: completion)
    }

    func fetchEntryCarbs(completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchEntryCarbs(completion: completion)
    }

    func fetchDailyCarbs(completion: @escaping ([CarbModel]) -> Void) {
        healthStore.fetchDailyCarbs(completion: completion)
    }

    func fetchFirstEntryCarbs(completion: @escaping (CarbModel) -> Void) {
        healthStore.fetchFirstEntryCarbs(completion: completion)
    }
}
