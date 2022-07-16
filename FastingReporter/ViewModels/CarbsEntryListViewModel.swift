//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol CarbsEntryListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func sortEntryCarbs()
    func updateEntryCarbs()
}

final class CarbsEntryListViewModel: ObservableObject {
    @Published var carbsListCVM: [CarbViewModel] = []   // NOTE: Published list to share data with the view.
    @Published var isLoading = false

    private var carbsList: [CarbModel] = []             // NOTE: Private list to receive data from the repository.
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
// NOTE: For classes (i.e. reference types), to avoid Memory Retain Cycle (i.e. Memory Leak), use weak self for one
//       class so the other class can be deinited.
extension CarbsEntryListViewModel: CarbsEntryListViewModelProtocol {
    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch, sort & update tasks
    //       for the carbs entry list for CarbModel (carbsList). Additionally, via dispatch (as noted above),
    //       continue with tasks to populate and sort carbs entry list for CarbViewModel (carbsListCVM).
    // NOTE: Async func.
    func fetchUpdateEntryCarbs() {
        // TODO: Find elegant place for constants like this.
        let myHKObjectQueryNoLimit = 0      // NOTE: My constant for HealthKit constant HKObjectQueryNoLimit (i.e. 0).
        let defaultDaysBack = -10
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        isLoading = true

        dispatchQueue.async { [weak self] in
            print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: fetchEntryCarbs: Completed")
            self?.healthRepository.fetchEntryCarbs(daysBack: defaultDaysBack, limit: myHKObjectQueryNoLimit)
            { [weak self] hCarbsList in
                self?.carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: sortEntryCarbs: Completed")
                // NOTE: Force a sort: I've observed quick delete of latest carb entry & back to app leads to bad sort.
                self?.sortEntryCarbs()
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: updateEntryCarbs: Completed")
                self?.updateEntryCarbs()
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: populateEntryCarbsCVM: Completed")
                self?.populateEntryCarbsCVM()
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: populateEntryCarbsCVM: carbsListCVM: ")
            print("Unsorted: \(String(describing: self?.carbsListCVM))")

            DispatchQueue.main.async { [weak self] in
            // DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: sortEntryCarbsCVM: Completed")
                self?.sortEntryCarbsCVM()
                self?.isLoading = false
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: sortEntryCarbsCVM: carbsListCVM: Sorted: ")
            print("\(String(describing: self?.carbsListCVM))")
        }
        print("DEBUG: CarbsEntryListViewModel.fetchUpdateEntryCarbs: Starting...")
    }

    func sortEntryCarbs() {
        carbsList.sort()
    }

    func updateEntryCarbs() {
        carbsList = healthRepository.updateEntryCarbs(carbsList: carbsList)
    }

    func populateEntryCarbsCVM() {
        carbsListCVM = carbsList.map(CarbViewModel.init)
    }

    func sortEntryCarbsCVM() {
        carbsListCVM.sort()
    }
}
