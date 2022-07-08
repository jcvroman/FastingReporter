//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol CarbsEntryListViewModelProtocol {
    var carbsList: [CarbModel] { get set }      // TODO: FIX: Verify this var implemention (i.e. get vs. private(set)).
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
// NOTE: Default Protocols: Implement it in extension, but can override it by implementing it again in struct, class...
// NOTE: Published changes to the UI must occur on the main thread.
// FIXME: TODO: Explicitly do all of the data work on the main thread plus avoid retain cycle via
//        'DispatchQueue.main.async { [weak self] in', but the unit tests fail using it?
// NOTE: For classes (i.e. reference types), to avoid Memory Retain Cycle (i.e. Memory Leak), use weak self for one
//       class so the other class can be deinited.
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

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch, sort & update tasks.
    func fetchSortUpdateEntryCarbs() {
        // FIXME: TODO: Find elegant place for constants like this.
        let myHKObjectQueryNoLimit = 0      // NOTE: My constant for HealthKit constant HKObjectQueryNoLimit (i.e. 0).
        let defaultDaysBack = -10
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async { [weak self] in
            print("DEBUG: CarbsEntryListViewModel.fetchEntryCarbs: Completed")
            self?.healthRepository.fetchEntryCarbs(daysBack: defaultDaysBack, limit: myHKObjectQueryNoLimit)
            { [weak self] hCarbsList in
                self?.carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async {
                print("DEBUG: CarbsEntryListViewModel.sortEntryCarbs: Completed")
                // NOTE: Force a sort: I've observed quick delete of latest carb entry & back to app leads to bad sort.
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
