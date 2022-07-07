//
//  CarbsDailyListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol CarbsDailyListViewModelProtocol {
    var carbsList: [CarbModel] { get }
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchDailyCarbs()
    func sortAllDailyCarbs()
}

final class CarbsDailyListViewModel: ObservableObject {
    @Published var carbsList: [CarbModel] = []

    private let healthRepository: HealthRepositoryProtocol
    
    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    func deint() {
        // FIXME: TODO: Why isn't this logged. Memory Retain Cycle issue?
        print("DEBUG: CarbsDailyListViewModel.deinit")
    }
}

// MARK: - CarbsDailyListViewModelProtocol
// NOTE: Default Protocols: Implement it in extension, but can still override it by implementing it again in the struct, class.
extension CarbsDailyListViewModel: CarbsDailyListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    func fetchDailyCarbs() {
        healthRepository.fetchDailyCarbs() { [weak self] hCarbsList in
            self?.carbsList = hCarbsList
            self?.sortAllDailyCarbs()        // NOTE: Must sort within the collection closure.
        }
    }

    func sortAllDailyCarbs() {
        // carbsList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsList.sort()
    }
}
