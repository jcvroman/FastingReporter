//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol CarbsEntryListViewModelProtocol {
    // var carbsList: [CarbModel] { get set }          // TODO: FIX: Verify this var implemention (i.e. get vs. private(set)).
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchEntryCarbs()
    func sortEntryCarbs()
    func updateEntryCarbs()
}

final class CarbsEntryListViewModel: ObservableObject {
    @Published var carbsList: [CarbModel] = []
    
    private let healthRepository: HealthRepositoryProtocol

    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    func deint() {
        // FIXME: TODO: Why isn't this logged. Memory Retain Cycle issue?
        print("DEBUG: CarbsEntryListViewModel.deinit")
    }
}

// MARK: - CarbsEntryListViewModelProtocol
// NOTE: Default Protocols: Implement it in extension, but can still override it by implementing it again in the struct, class.
extension CarbsEntryListViewModel: CarbsEntryListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    func fetchEntryCarbs() {
        healthRepository.fetchEntryCarbs() { hCarbsList in
            self.carbsList = hCarbsList

            // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
            self.sortEntryCarbs()        // FIX: BUG: Why must I sort/update within the collection closure. I.e. loop loop thru.
            self.updateEntryCarbs()
        }
    }

    func sortEntryCarbs() {
        carbsList.sort()
    }

    func updateEntryCarbs() {
        carbsList = healthRepository.updateEntryCarbs(carbsList: carbsList)
    }
    
    func fetchSortUpdateEntryCarbs() {
        self.fetchEntryCarbs()
        // self.sortEntryCarbs()
        // self.updateEntryCarbs()
    }
}
