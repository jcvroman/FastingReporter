//
//  CurrentFastViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/5/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
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
// NOTE: Default Protocols: Implement it in extension, but can still override it by implementing it again in the struct, class.
extension CurrentFastViewModel: CurrentFastViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    func fetchEntryCarbsFirst() {
        healthRepository.fetchEntryCarbsFirst() { [weak self] hCarbsFirst in
            print("DEBUG: CurrentFastViewModel.fetchEntryCarbsFirst: hCarbsFirst: \(hCarbsFirst)")
            self?.carbsFirst = hCarbsFirst
        }
        print("DEBUG: CurrentFastViewModel.fetchEntryCarbsFirst: carbsFirst: \(String(describing: carbsFirst))")
    }
}
