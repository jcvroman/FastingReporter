//
//  HealthRepositoryMock.swift
//  FastingReporterTests
//
//  Created by Jimmy Vroman on 7/9/22.
//

import Foundation
@testable import FastingReporter

final class HealthRepositoryMock {
    let items: [CarbModel]

    // NOTE: Pass in items or if nil use below defaults.
    init(items: [CarbModel]?) {
        self.items = items ?? [
            CarbModel(carbs: 1, date: Date())
        ]
    }
}

// MARK: - HealthRepositoryProtocol
extension HealthRepositoryMock: HealthRepositoryProtocol {
    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
    }

    // NOTE: Async func.
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void) {
    }

    // NOTE: Async func.
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void) {
        completion(items)
    }

    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel] {
        return items
    }
}
