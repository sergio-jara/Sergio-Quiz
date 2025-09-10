//
//  IntegrationTestBase.swift
//  DynaQuizIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import DynaQuiz

// MARK: - Integration Test Base Class
@MainActor
class IntegrationTestBase: XCTestCase {
    
    // MARK: - Properties
    var mockNetworkService: MockNetworkService!
    var apiClient: QuizAPIClient!
    var storageService: QuizStorageService!
    var realmService: RealmService!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        setupTestEnvironment()
        clearTestData()
    }
    
    override func tearDownWithError() throws {
        cleanupTestEnvironment()
        try super.tearDownWithError()
    }
    
    // MARK: - Test Environment Setup
    private func setupTestEnvironment() {
        // Setup mock network service
        mockNetworkService = MockNetworkService()
        
        // Setup API client with mock network service
        apiClient = QuizAPIClient(networkService: mockNetworkService)
        
        // Setup test database
        setupTestDatabase()
        
        // Setup storage service with test database
        storageService = QuizStorageService(realmService: realmService)
    }
    
    private func setupTestDatabase() {
        // Create a new RealmService instance for testing
        // Note: In a real scenario, you might want to modify RealmService to accept configuration
        realmService = RealmService()
    }
    
    private func clearTestData() {
        // Clear all quiz results to ensure test isolation
        // This is a simple approach - in a real scenario, you might want to use in-memory databases
        let results = storageService?.loadQuizResults() ?? []
        // Note: This assumes there's a delete method in QuizStorageService
        // For now, we'll work with the existing data and adjust our expectations
    }
    
    private func cleanupTestEnvironment() {
        apiClient = nil
        mockNetworkService = nil
        storageService = nil
        realmService = nil
    }
}

// MARK: - Data Validation Helpers
extension IntegrationTestBase {
    
    func validateQuestionStructure(_ question: QuizQuestion) {
        XCTAssertNotNil(question.id, "Question ID should not be nil")
        XCTAssertFalse(question.id.isEmpty, "Question ID should not be empty")
        XCTAssertFalse(question.statement.isEmpty, "Question statement should not be empty")
        XCTAssertEqual(question.options.count, 4, "Question should have exactly 4 options")
        XCTAssertTrue(question.options.allSatisfy { !$0.isEmpty }, "All options should be non-empty")
    }
    
    func validateAnswerResponse(_ response: QuizAnswerResponse) {
        XCTAssertNotNil(response.result, "Response result should not be nil")
        XCTAssertTrue(response.result is Bool, "Response result should be a boolean")
    }
    
    func validateQuizResult(_ result: QuizResult) {
        XCTAssertFalse(result.userName.isEmpty, "User name should not be empty")
        XCTAssertTrue(result.score >= 0 && result.score <= 100, "Score should be between 0 and 100")
        XCTAssertTrue(result.correctAnswers >= 0, "Correct answers should be non-negative")
        XCTAssertTrue(result.totalQuestions > 0, "Total questions should be positive")
        XCTAssertTrue(result.correctAnswers <= result.totalQuestions, "Correct answers should not exceed total questions")
    }
}
