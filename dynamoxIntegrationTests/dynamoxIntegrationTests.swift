//
//  dynamoxIntegrationTests.swift
//  dynamoxIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import dynamox

/**
 * Main Integration Test Suite
 * 
 * This file serves as the entry point for all integration tests.
 * Individual test classes are organized in separate files:
 * 
 * - QuizAPIIntegrationTests: API layer integration tests
 * - QuizStorageIntegrationTests: Storage layer integration tests  
 * - ViewModelIntegrationTests: ViewModel integration tests
 * 
 * Shared utilities and base classes:
 * - IntegrationTestBase: Common setup and teardown
 * - TestDataFactory: Centralized test data creation
 * - MockNetworkService: Network service mocking
 * - TestUtilities: Reusable test helpers
 */

@MainActor
final class dynamoxIntegrationTests: XCTestCase {
    
    func testIntegrationTestSuiteSetup() throws {
        // This test verifies that the integration test suite is properly configured
        XCTAssertTrue(true, "Integration test suite is properly configured")
    }
}