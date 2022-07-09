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
    var sut: CarbsDailyListViewModel!                   // NOTE: sut = Subject Under Test.
    var healthRepositoryMock: HealthRepositoryMock!     // NOTE: Using Mock here so no HealthStore data needed.
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        super.setUp()
        healthRepositoryMock = HealthRepositoryMock(items: nil)
        sut = .init(healthRepository: healthRepositoryMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        healthRepositoryMock = nil
        super.tearDown()
    }

    func test_when_sut_inited_then_list_empty() throws {
        // When: init sut already.

        // Then
        XCTAssert(sut.carbsList.isEmpty, "carbsList should be empty at sut init.")
    }

    func test_when_daily_carbs_exist_then_list_not_empty() throws {
        // When
        let expectation = XCTestExpectation(description: "Should wait & return items from async work.")

        sut.$carbsList
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchDailyCarbs()

        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertFalse(self.sut.carbsList.isEmpty, "carbsList should not be empty after fetch.")
    }
}
