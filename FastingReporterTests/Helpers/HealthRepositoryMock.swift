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
    let itemsCVM: [CarbViewModel]

    // NOTE: Pass in items or if nil use below defaults.
    init(items: [CarbModel]?, itemsCVM: [CarbViewModel]?) {
        self.items = items ?? [
            CarbModel(carbs: 1, date: Date())
        ]
        self.itemsCVM = itemsCVM ?? [
            CarbViewModel(carb: CarbModel(carbs: 10, date: Date()))
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
}
