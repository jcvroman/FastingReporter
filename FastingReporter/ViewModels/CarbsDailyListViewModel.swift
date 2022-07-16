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
    func sortDailyCarbsCVM()
}

final class CarbsDailyListViewModel: ObservableObject {
    @Published var carbsListCVM: [CarbViewModel] = []   // NOTE: Published list to share data with the view.
    @Published var isLoading = false

    private var carbsList: [CarbModel] = []             // NOTE: Private list to receive data from the repository.
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
    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch & sort tasks
    //       for the carbs daily list for CarbModel (carbsList). Additionally, via dispatch (as noted above),
    //       continue with tasks to populate and sort carbs entry list for CarbViewModel (carbsListCVM).
    // NOTE: Async func.
    func fetchDailyCarbs() {
        let defaultDaysBack = -100
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        isLoading = true

        dispatchQueue.async { [weak self] in
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: Completed")
            self?.healthRepository.fetchDailyCarbs(daysBack: defaultDaysBack) { [weak self] hCarbsList in
                self?.carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: carbsList: \(String(describing: self?.carbsList))")

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: populateDailyCarbsCVM: Completed")
                self?.populateDailyCarbsCVM()
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: populateDailyCarbsCVM: carbsListCVM: Unsorted: ")
            print("\(String(describing: self?.carbsListCVM))")

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: sortDailyCarbsCVM: Completed")
                self?.sortDailyCarbsCVM()
                self?.isLoading = false
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: sortDailyCarbsCVM: carbsListCVM: Sorted:")
            print("\(String(describing: self?.carbsListCVM))")
        }
        print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: Starting...")
    }

    func populateDailyCarbsCVM() {
        carbsListCVM = carbsList.map(CarbViewModel.init)
    }

    func sortDailyCarbsCVM() {
        // carbsList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsListCVM.sort()
    }
}
