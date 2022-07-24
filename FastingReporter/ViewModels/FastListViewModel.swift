//
//  FastListViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/24/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol FastListViewModelProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchFastList()
    func fetchCreateFastList(daysBack: Int, limit: Int, completion: @escaping ([CarbViewModel]) -> Void)
    func fetchEntryCarbsCM(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void)
    func sortEntryCarbsCM(completion: @escaping ([CarbModel]) -> Void)
    func updateEntryCarbsCM(completion: @escaping ([CarbModel]) -> Void)
    func populateEntryCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void)
    func sortEntryCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void)
    func createFastListCVM(completion: @escaping ([CarbViewModel]) -> Void)
}

final class FastListViewModel: ObservableObject {
    @Published var carbsListCVM: [CarbViewModel] = []   // NOTE: Published list to share data with the view.
    @Published var fastList: [CarbViewModel] = []
    @Published var isLoading = false

    private var carbsList: [CarbModel] = []             // NOTE: Private list to receive data from the repository.
    private let healthUseCases: HealthUseCasesProtocol

    init(healthUseCases: HealthUseCasesProtocol = HealthUseCases()) {     // NOTE: Dependency Injection.
        self.healthUseCases = healthUseCases
    }

    func deint() {
        // FIXME: TODO: Why isn't this logged. Memory Retain Cycle issue?
        print("DEBUG: FastListViewModel.deinit")
    }
}

// MARK: - FastListViewModelProtocol
// NOTE: Default Protocols: Implement it in extension, but can override it by implementing it again in struct, class...
// NOTE: Published changes to the UI must occur on the main thread.
// NOTE: For classes (i.e. reference types), to avoid Memory Retain Cycle (i.e. Memory Leak), use weak self for one
//       class so the other class can be deinited.
extension FastListViewModel: FastListViewModelProtocol {
    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthUseCases.requestAuthorization(completion: completion)
    }

    // NOTE: Manage the async calls to fetch, sort, update, populate, sort and creat the fast list.
    // NOTE: Mange async calls by nested closures. Furthermore, pass each method as a closure agrument in a managing
    //       method to improve readability.
    // NOTE: Async func.
    func fetchFastList() {
        // TODO: Find elegant place for constants like this.
        let myHKObjectQueryNoLimit = 0      // NOTE: My constant for HealthKit constant HKObjectQueryNoLimit (i.e. 0).
        let defaultDaysBack = -10

        isLoading = true

        print("DEBUG: FastListViewModel.fetchFastList: fetchCreateFastList: Starting...")
        fetchCreateFastList(daysBack: defaultDaysBack, limit: myHKObjectQueryNoLimit) { [weak self] dataList in
            print("DEBUG: FastListViewModel.fetchFastList: fetchCreateFastList: Completed")
            self?.fastList = dataList
            self?.isLoading = false
        }
    }

    // NOTE: Fetch, sort, update, populate, sort and creat the fast list.
    // NOTE: Async func.
    func fetchCreateFastList(daysBack: Int, limit: Int, completion: @escaping ([CarbViewModel]) -> Void) {
        fetchEntryCarbsCM(daysBack: daysBack, limit: limit) { [weak self] dataList in
            self?.sortEntryCarbsCM() { dataList in
                self?.updateEntryCarbsCM() { dataList in
                    self?.populateEntryCarbsCVM() { dataList in
                        self?.sortEntryCarbsCVM() { dataList in
                            self?.createFastListCVM() { dataList in
                                completion(dataList)
                            }
                        }
                    }
                }
            }
        }
    }

    // NOTE: Async func.
    func fetchEntryCarbsCM(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthUseCases.fetchEntryCarbs(daysBack: daysBack, limit: limit) { [weak self] dataList in
            self?.carbsList = dataList
            completion(dataList)
        }
    }

    // NOTE: Async func.
    func sortEntryCarbsCM(completion: @escaping ([CarbModel]) -> Void) {
        // carbsListCVM.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsList.sort()
        completion(carbsList)
    }

    // NOTE: Async func.
    func updateEntryCarbsCM(completion: @escaping ([CarbModel]) -> Void) {
        carbsList = healthUseCases.updateEntryCarbs(carbsList: carbsList)
        completion(carbsList)
    }

    // NOTE: Async func.
    func populateEntryCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void) {
        carbsListCVM = carbsList.map(CarbViewModel.init)
        completion(carbsListCVM)
    }

    // NOTE: Async func.
    func sortEntryCarbsCVM(completion: @escaping ([CarbViewModel]) -> Void) {
        // carbsListCVM.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        carbsListCVM.sort()
        completion(carbsListCVM)
    }

    // NOTE: Async func.
    func createFastListCVM(completion: @escaping ([CarbViewModel]) -> Void) {
        fastList = healthUseCases.createFastList(carbsListCVM: carbsListCVM)
        completion(fastList)
    }
}
