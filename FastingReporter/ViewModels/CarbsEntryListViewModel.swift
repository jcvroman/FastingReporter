//
//  CarbsEntryListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties and other requirements that suit a particular task or piece of functionality.
protocol CarbsEntryListViewModelProtocol {
    var carbsList: [CarbModel] { get }          // TODO: FIX: Verify this var implemention (i.e. get vs. private(set)).
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchEntryCarbs()
    func sortAllEntryCarbs()
    func updateAllEntryCarbs()
}

final class CarbsEntryListViewModel: ObservableObject {
    @Published private(set) var carbsList: [CarbModel] = []
    
    private let healthRepository: HealthRepositoryProtocol

    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    func deint() {
        // FIXME: TODO: Why isn't this logged. Memory Retain Cycle issue?
        print("DEBUG: CarbsEntryListViewModel: deinit")
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
            // TODO: Verify this is a robust fix for warning about publishing changes from main thread.
            DispatchQueue.main.async {
                self.carbsList = hCarbsList

                // NOTE: Force a sort as I've observed a quick delete of latest carb entry and back to app leads to bad sort.
                self.sortAllEntryCarbs()        // NOTE: Must sort within the collection closure.
                self.updateAllEntryCarbs()
            }
        }
    }

    func sortAllEntryCarbs() {
        self.carbsList.sort()
    }

    // TODO: Move this to healthRepository.
    func updateAllEntryCarbs() {
        var carbsList2: [CarbModel] = []
        // print("updateAllEntryCarbs: carbsList: \(carbsList)")
        for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
            lhs.previousDate = rhs.date
            // FIX: TODO: Clean up. No force unwrap.
            lhs.diffMinutes = Calendar.current
                .dateComponents([.minute], from: lhs.previousDate!, to: lhs.date)
                .minute
            carbsList2.append(lhs)
            // print("updateAllEntryCarbs: carb: \(lhs.carbs); date: \(lhs.date);previous date: \(lhs.previousDate ?? Date());")
            // print("    diff minutes: \(lhs.diffMinutes ?? 0); id: \(lhs.id)")
        }
        carbsList2.append(carbsList.last!)       // NOTE: Append back last element.
        self.carbsList = carbsList2
    }
}
