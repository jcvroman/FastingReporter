//
//  CarbsDailyListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

final class CarbsDailyListViewModel: ObservableObject {
    @Published private(set) var carbsList: [CarbModel] = []

    private let healthRepository: HealthRepositoryProtocol
    
    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }
    
    func fetchDailyCarbs() {
        healthRepository.fetchDailyCarbs() { hCarbsList in
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                self.carbsList = hCarbsList
                self.sortAllDailyCarbs()        // NOTE: Must sort within the collection closure.
            }
        }
    }

    func sortAllDailyCarbs() {
        // self.carbsList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        self.carbsList.sort()
    }
}
