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

import XCTest
@testable import FastingReporter

// Feature: Report List
class CarbsDailyListViewModelTests: XCTestCase {
    // Scenario: Report List when no carbs data is an empty list.
    func test_when_no_carbs_then_report_list_empty() throws {
        let sut = CarbsDailyListViewModel()
        // sut.fetchList()
        // XCTAssert(sut.list.isEmpty, "lists should be empty at sut init.")
        XCTAssert(true, "Test to be written.")
    }
}
