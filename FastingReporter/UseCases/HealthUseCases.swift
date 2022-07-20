//
//  HealthUseCases.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/19/22.
//

import Foundation

// NOTE: Protocol: A blueprint of methods, properties & other requirements that suit a task or piece of functionality.
protocol HealthUseCasesProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void)
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void)
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel]
    func createFastList(carbsListCVM: [CarbViewModel]) -> [CarbViewModel]
}

final class HealthUseCases: HealthUseCasesProtocol {
    private let healthRepository: HealthRepositoryProtocol

    init(healthRepository: HealthRepositoryProtocol = HealthRepository()) {     // NOTE: Dependency Injection.
        self.healthRepository = healthRepository
    }

    // NOTE: Async func.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthRepository.requestAuthorization(completion: completion)
    }

    // NOTE: Async func.
    func fetchEntryCarbs(daysBack: Int, limit: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthRepository.fetchEntryCarbs(daysBack: daysBack, limit: limit, completion: completion)
    }

    // NOTE: Async func.
    func fetchDailyCarbs(daysBack: Int, completion: @escaping ([CarbModel]) -> Void) {
        healthRepository.fetchDailyCarbs(daysBack: daysBack, completion: completion)
    }

    // MARK: - Business Logic.
    // NOTE: Update carbs list with previous date (i.e. previous item's date).
    func updateEntryCarbs(carbsList: [CarbModel]) -> [CarbModel] {
        var carbsListWork: [CarbModel] = []
        // print("DEBUG: HealthUseCases.updateEntryCarbs: carbsList: \(carbsList)")

        // NOTE: Loop thru carbsList & carbsList next element in order to assign next element item to current one.
        for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
            lhs.previousDate = rhs.date

            // NOTE: Get minutes from previous date to date.
            lhs.diffSeconds = Calendar.current
                .dateComponents([.second], from: lhs.previousDate!, to: lhs.date)  // FIXME: Clean up. No force unwrap.
                .second
            carbsListWork.append(lhs)
        }
        if let carbsListLast = carbsList.last {
            carbsListWork.append(carbsListLast)    // NOTE: Append back last element as it was dropped off of loop per.
        }

        print("DEBUG: HealthUseCases.updateEntryCarbs: carbsListWork: \(carbsListWork)")
        return carbsListWork
    }

    // NOTE: Create fast list. I.e. the longest fast ending on a date (e.g. it may start on the previous date).
    //       For a date, include the previous date (i.e. search back into the previous date).
    func createFastList(carbsListCVM: [CarbViewModel]) -> [CarbViewModel] {
        var carbsListCVMOrg: [CarbViewModel] = []
        var fastListWork: [CarbViewModel] = []
        var fastListNew: [CarbViewModel] = []
        // print("DEBUG: HealthUseCases.createFastList: carbsListCVM: \(carbsListCVM)")

        // NOTE: Remember carbs list CVM sorted descending.
        carbsListCVMOrg = carbsListCVM.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        
        // NOTE: Get a list of dates. Sorted descending. Removed duplicates, so only unique dates.
        let dateList = carbsListCVM.map { $0.dateDateStr }
        let dateListUnique = dateList.removingDuplicates()
        // print("DEBUG: HealthUseCases.createFastList: dateListUnique: \(dateListUnique)")

        // NOTE: 1. Loop thru dates: 1a. Filter on date. 1b. Sort on diffSeconds. 1c. Note 1st (i.e. biggest).
        //       1d. append biggest to new list. 1e. continue loop.
        //       2. Drop last one from new list as last date doesn't extend back into previous date.
        for date in dateListUnique {
            fastListWork = carbsListCVMOrg.filter { $0.dateDateStr == date }
            fastListWork = fastListWork.sorted(by: \.diffSeconds, using: >)
            let fastListWorkFirstID = fastListWork.first?.id
            fastListWork = fastListWork.filter { $0.id == fastListWorkFirstID }
            fastListNew.append((fastListWork.first)!)
            // print("DEBUG: HealthUseCases.createFastList: date: \(date)")
        }
        fastListNew = fastListNew.dropLast()

        print("DEBUG: HealthUseCases.createFastList: fastListNew: \(fastListNew)")
        return fastListNew
    }
}
