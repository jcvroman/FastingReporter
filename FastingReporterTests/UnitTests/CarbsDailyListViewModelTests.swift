//
//  CarbsDailyListViewModelTests.swift
//  FastingReporterTests
//
//  Created by Jimmy Vroman on 6/6/21.
//

// NOTE: Test Driven Development (TDD): Test, code, refactor. Focuses on implmentation apsects. Transparency factor
//       might be missing. Subset of BDD.
// NOTE: TDD: Red (write test to fail), Green (write code to pass test), Yellow (refactor) and iterate process.
// NOTE: Write testable code in order to avoid Mocks, Fakes, Stubs, Spies as much as possible. But, use simple Mocks,
//       Fakes, Stubs, Spies when needed.
// NOTE: Use the iOS Unit Tests across all OSes via setting the target membership for these test files.
// NOTE: macOS: Set the Signing Certificate to Development (i.e. from target Racket (macOS) / Signing &
//       Capabilities / Signing) for all tests.

import Combine
import XCTest
@testable import FastingReporter

// Feature: Report List
// Scenario: TDD Unit Tests
class CarbsDailyListViewModelTests: XCTestCase {
    // var sut: CarbsDailyListViewModel!                   // NOTE: sut = Subject Under Test.
    // var healthRepositoryMock: HealthRepositoryMock!     // NOTE: Using Mock here so no HealthStore data needed.
    let defaultExpectationTimeout: Double = 5
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        super.setUp()
        // healthRepositoryMock = HealthRepositoryMock(items: nil)
        // sut = .init(healthRepository: healthRepositoryMock)
    }

    override func tearDownWithError() throws {
        // sut = nil
        // healthRepositoryMock = nil
        cancellables = []
        super.tearDown()
    }

    private func makeSUT(items: [CarbModel], itemsCVM: [CarbViewModel]) -> CarbsDailyListViewModel {
        var sut = CarbsDailyListViewModel()
        let healthRepositoryMock = HealthRepositoryMock(items: items, itemsCVM: itemsCVM)
        sut = .init(healthRepository: healthRepositoryMock)
        return sut
    }

    func test_given_daily_carbs_0_items_when_no_fetch_then_list_empty() throws {
        // Given
        let sut = makeSUT(items: [], itemsCVM: [])

        // When: no fetch.

        // Then
        XCTAssert(sut.carbsListCVM.isEmpty, "carbsListCVM should be empty with no fetchDailyCarbs.")
    }

    func test_given_daily_carbs_1_items_when_fetch_then_list_not_empty() throws {
        // Given
        let items = [CarbModel(carbs: 1, date: Date())]
        // let itemsCVM = [CarbViewModel(carb: CarbModel(carbs: 10, date: Date()))]
        let sut = makeSUT(items: items, itemsCVM: [])

        // When
        let expectation = XCTestExpectation(description: "Should wait & return items from async work.")

        sut.$carbsListCVM
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchDailyCarbs()

        // Then
        wait(for: [expectation], timeout: defaultExpectationTimeout)
        XCTAssertFalse(sut.carbsListCVM.isEmpty, "carbsListCVM should not be empty after fetch.")
    }
}
