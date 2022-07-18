//
//  CarbsDailyListUITests.swift
//  FastingReporterUITests
//
//  Created by Jimmy Vroman on 6/6/21.
//

// NOTE: Continuous Delivery (CD): Testing Strategy for DevOps: Commit Cyle, Acceptance Cycle, Release Cycle,
//       Product Cycle.
//          Commit Cycle: Unit Test, Coding Standards Asserted, Common Error Detection.
//          Acceptance Cycle: Acceptance Tests, Deployment Tests, Data Migration Tests, Performance Tests.
//          Release Cycle: Smoke Tests (Health Check), Monitoring.
//          Product Cycle: Monitoring, Performance Verification, Security Verification.
// NOTE: Behavior Driven Development (BDD): TDD + Behavior. Focuses on behavioral apsects. Transparency between user
//       expectations & developers tests. Can be a superset of TDD.
// NOTE: BDD: Red (write test to fail), Green (write code to pass test), Yellow (refactor) and iterate process.
// NOTE: BDD: BDD Reference: https://cucumber.io/docs/bdd/
// NOTE: BDD: Gherkin Reference: https://cucumber.io/docs/gherkin/
// NOTE: BDD: Gherkin language: Gherkin is a business readable language which helps you to describe business behavior
//       without going into details of implementation.
//          It is a domain specific language for defining tests in Cucumber format for specifications. It uses plain
//          language to describe use cases and allows users
//            to remove logic details from behavior tests.
// NOTE: I'm using the Gherkin language for Acceptance tests (i.e. BDD) and all other tests (e.g. Unit tests), but not
//       Cucumber.
// NOTE: Use the iOS Unit Tests across all OSes via setting the target membership for these test files.
// NOTE: macOS: Set the Signing Certificate to Development (i.e. from target Racket (macOS) / Signing &
//       Capabilities / Signing) for all tests.

import XCTest

// Feature: Report List
class CarbsDailyListUITests: XCTestCase {
    // Scenario: Report List when no carbs data is an empty list.
    func test_when_no_carbs_then_report_list_empty() throws {
        // Given: User launches app. No carbs data for yesterday.
        XCUIApplication().launch()

        // Then: User should see a Carbs Daily List.
        let carbsDailyRowLabel = XCUIApplication().staticTexts["carbsDailyRowLabel"]
        // XCTAssertEqual("No carbs data.", carbsDailyRowLabel.label)
        XCTAssert(true, "Test to be written.")
    }
}
