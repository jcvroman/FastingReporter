//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol CarbsEntryListViewModelProtocol {
    var carbsList: [CarbModel] { get set }          // TODO: FIX: Verify this var implemention (i.e. get vs. private(set)).
    func requestAuthorization(completion: @escaping (Bool) -> Void)
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

    func sortEntryCarbs() {
        carbsList.sort()
    }

    func updateEntryCarbs() {
        carbsList = healthRepository.updateEntryCarbs(carbsList: carbsList)
    }

    // NOTE: Via dispatch queues (background and main) and semaphores, manage the completion of fetch, sort & update tasks.
    func fetchSortUpdateEntryCarbs() {
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async { [weak self] in
            print("DEBUG: CarbsEntryListViewModel.fetchEntryCarbs: Completed")
            self?.healthRepository.fetchEntryCarbs() { [weak self] hCarbsList in
                self?.carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async {
                print("DEBUG: CarbsEntryListViewModel.sortEntryCarbs: Completed")
                // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
                self?.sortEntryCarbs()
                semaphore.signal()
            }
            semaphore.wait()
            
            DispatchQueue.main.async {
                print("DEBUG: CarbsEntryListViewModel.updateEntryCarbs: Completed")
                self?.updateEntryCarbs()
                semaphore.signal()
            }
            semaphore.wait()
        }
        print("DEBUG: CarbsEntryListViewModel.fetchSortUpdateEntryCarbs: Starting...")
    }
}
