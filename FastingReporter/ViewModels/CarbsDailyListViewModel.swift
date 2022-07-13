//
//  CarbsDailyListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol CarbsDailyListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchDailyCarbs()
    func sortDailyCarbs()
}

final class CarbsDailyListViewModel: ObservableObject {
    @Published var carbsListCVM: [CarbViewModel] = []

    private var carbsList: [CarbModel] = []
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
// NOTE: Default Protocols: Implement it in extension, but can override it by implementing it again in struct, class...
extension CarbsDailyListViewModel: CarbsDailyListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch, populate &
    //       sort tasks.
    func fetchDailyCarbs() {
        let defaultDaysBack = -100
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async { [weak self] in
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: Completed")
            self?.healthRepository.fetchDailyCarbs(daysBack: defaultDaysBack) { [weak self] hCarbsList in
                self?.carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: carbsList: \(String(describing: self?.carbsList))")

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: populateDailyCarbs: Completed")
                self?.populateDailyCarbs()
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: populateDailyCarbs: carbsListCVM: Unsorted: \(String(describing: self?.carbsListCVM))")

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: sortDailyCarbs: Completed")
                self?.sortDailyCarbs()
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: sortDailyCarbs: carbsListVM: Sorted \(String(describing: self?.carbsListCVM))")
        }
        print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: Starting...")
    }

    func populateDailyCarbs() {
        carbsListCVM = carbsList.map(CarbViewModel.init)
    }

    func sortDailyCarbs() {
        // carbsList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsListCVM.sort()
    }
}
