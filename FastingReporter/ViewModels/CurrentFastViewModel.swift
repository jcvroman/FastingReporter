//
//  CurrentFastViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/5/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol CurrentFastViewModelProtocol {
    // var carbsFirst: CarbModel { get }        // TODO: FIX: How to implement this var like carbsList?
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchEntryCarbsFirst()
}

final class CurrentFastViewModel: ObservableObject {
    @Published var carbsFirst: CarbModel?

    private let healthRepository: HealthRepositoryProtocol

    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    func deint() {
        // FIXME: TODO: Why isn't this logged. Memory Retain Cycle issue?
        print("DEBUG: CurrentFastViewModel.deinit")
    }
}

// MARK: - CurrentFastViewModelProtocol
// NOTE: Default Protocols: Implement it in extension, but can override it by implementing it again in struct, class...
extension CurrentFastViewModel: CurrentFastViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    // NOTE: Via dispatch queues (background & main) & semaphores, manage the completion of fetch 1st entry carb via
    //       fetchEntryCarbs.
    func fetchEntryCarbsFirst() {
        var carbsList: [CarbModel] = []
        let defaultDaysBack = -1
        let defaultLimit = 1
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async { [weak self] in
            print("DEBUG: CurrentFastViewModel.fetchEntryCarbs: Completed")
            self?.healthRepository.fetchEntryCarbs(daysBack: defaultDaysBack, limit: defaultLimit) { hCarbsList in
                carbsList = hCarbsList
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CurrentFastViewModel.fetchEntryCarbsFirst: carbsList: \(String(describing: carbsList))")

            DispatchQueue.main.async { [weak self] in
                print("DEBUG: CurrentFastViewModel.carbsFirst: assigned: Completed")
                self?.carbsFirst = carbsList.first
                semaphore.signal()
            }
            semaphore.wait()
            print("DEBUG: CurrentFastViewModel.fetchEntryCarbsFirst: carbsFirst: \(String(describing: self?.carbsFirst))")
        }
        print("DEBUG: CurrentFastViewModel.fetchEntryCarbsFirst: Starting...")
    }
}
