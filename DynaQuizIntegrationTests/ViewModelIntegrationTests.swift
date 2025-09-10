//
//  ViewModelIntegrationTests.swift
//  DynaQuizIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import DynaQuiz

@MainActor
final class ViewModelIntegrationTests: IntegrationTestBase {
    
    // MARK: - Setup
    // No mock dependencies needed since we removed the integration tests
    // that were using mocks. Only WelcomeViewModel tests remain, which
    // don't require any dependencies.
    
    // MARK: - Integration Tests Removed
    // The following integration tests were removed because they were testing
    // ViewModels with mock dependencies, which doesn't provide meaningful
    // integration testing. These should be unit tests instead.
    
    // MARK: - WelcomeViewModel Integration Tests
    
    func testWelcomeViewModelIntegration() throws {
        // Given: WelcomeViewModel
        let viewModel = WelcomeViewModel()
        
        // When: Testing name validation
        viewModel.userName = "John Doe"
        viewModel.validateName("John Doe")
        
        // Then: Verify validation works
        XCTAssertTrue(viewModel.isNameValid)
        XCTAssertTrue(viewModel.canStartQuiz)
        XCTAssertEqual(viewModel.getTrimmedName(), "John Doe")
    }
    
    func testWelcomeViewModelInvalidNameIntegration() throws {
        // Given: WelcomeViewModel
        let viewModel = WelcomeViewModel()
        
        // When: Testing invalid name validation
        viewModel.userName = "A"
        viewModel.validateName("A")
        
        // Then: Verify invalid name handling
        XCTAssertFalse(viewModel.isNameValid)
        XCTAssertFalse(viewModel.canStartQuiz)
    }
    
    func testWelcomeViewModelWhitespaceHandlingIntegration() throws {
        // Given: WelcomeViewModel
        let viewModel = WelcomeViewModel()
        
        // When: Testing name with whitespace
        viewModel.userName = "  Jane Smith  "
        viewModel.validateName("  Jane Smith  ")
        
        // Then: Verify whitespace handling
        XCTAssertTrue(viewModel.isNameValid)
        XCTAssertTrue(viewModel.canStartQuiz)
        XCTAssertEqual(viewModel.getTrimmedName(), "Jane Smith")
    }
    
    // MARK: - Cross-ViewModel Integration Tests Removed
    // Cross-ViewModel integration tests were removed because they were testing
    // ViewModels with mock dependencies, which doesn't provide meaningful
    // integration testing. Real integration tests would require actual
    // network calls and database operations.
}

// MARK: - Mock Classes Removed
// Mock classes were removed because the integration tests that used them
// were also removed. These mocks were not providing meaningful integration
// testing since they were just testing ViewModels with fake dependencies.
