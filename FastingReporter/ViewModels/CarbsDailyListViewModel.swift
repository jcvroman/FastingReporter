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
    func fetchPopulateSortDailyCarbs(daysBack: Int, completion: @escaping ([CarbViewModel]) -> Void)
    func fetchDailyCarbsCM(daysBack: Int, completion: @escaping ([CarbModel]) -> Void)
    func populateDailyCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void)
    func sortDailyCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void)
}

final class CarbsDailyListViewModel: ObservableObject {
    @Published var carbsListCVM: [CarbViewModel] = []   // NOTE: Published list to share data with the view.
    @Published var isLoading = false

    private var carbsList: [CarbModel] = []             // NOTE: Private list to receive data from the repository.
    private let healthUseCases: HealthUseCasesProtocol

    init(healthUseCases: HealthUseCasesProtocol = HealthUseCases()) {     // NOTE: Dependency Injection.
        self.healthUseCases = healthUseCases
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
        healthUseCases.requestAuthorization(completion: completion)
    }

    // NOTE: Manage the async calls to fetch, populate and sort the daily carbs list.
    // NOTE: Mange async calls by nested closures. Furthermore, pass each method as a closure agrument in a managing
    //       method to improve readability.
    // NOTE: Async func.
    func fetchDailyCarbs() {
        let defaultDaysBack = -999

        isLoading = true

        print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: fetchPopulateSortDailyCarbs: Starting...")
        fetchPopulateSortDailyCarbs(daysBack: defaultDaysBack) { [weak self] dataList in
            print("DEBUG: CarbsDailyListViewModel.fetchDailyCarbs: fetchPopulateSortDailyCarbs: Completed")
            self?.carbsListCVM = dataList
            self?.isLoading = false
        }
    }

    // NOTE: Async func.
    func fetchPopulateSortDailyCarbs(daysBack: Int, completion: @escaping ([CarbViewModel]) -> Void) {
        fetchDailyCarbsCM(daysBack: daysBack) { [weak self] dataList in
            self?.populateDailyCarbsCVM() { dataList in
                self?.sortDailyCarbsCVM() { dataList in
                    // self?.isLoading = false
                    completion(dataList)
                }
            }
        }
    }

    // NOTE: Async func.
    func fetchDailyCarbsCM(daysBack: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthUseCases.fetchDailyCarbs(daysBack: daysBack) { [weak self] dataList in
            self?.carbsList = dataList
            completion(dataList)
        }
    }

    // NOTE: Async func.
    func populateDailyCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void) {
        carbsListCVM = carbsList.map(CarbViewModel.init)
        completion(carbsListCVM)
    }

    // NOTE: Async func.
    func sortDailyCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void) {
        // carbsListCVM.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsListCVM.sort()
        completion(carbsListCVM)
    }
}
