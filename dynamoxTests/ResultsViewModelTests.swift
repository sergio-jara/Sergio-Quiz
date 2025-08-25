//
//  ResultsViewModelTests.swift
//  dynamoxTests
//
//  Created by sergio jara on 25/08/25.
//

import XCTest
@testable import dynamox

@MainActor
final class ResultsViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var mockQuizStorageService: MockQuizStorageService!
    private var viewModel: ResultsViewModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        mockQuizStorageService = MockQuizStorageService()
        viewModel = ResultsViewModel(quizStorageService: mockQuizStorageService)
    }
    
    override func tearDownWithError() throws {
        mockQuizStorageService = nil
        viewModel = nil
    }
    
    // MARK: - ResultsViewModel Tests
    
    func testResultsViewModelInitialState() throws {
        // Test initial state
        XCTAssertTrue(viewModel.recentResults.isEmpty)
        XCTAssertEqual(viewModel.totalQuizzes, 0)
        XCTAssertEqual(viewModel.averageScore, 0)
        XCTAssertFalse(viewModel.hasResult)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testResultsViewModelLoadResultsSuccess() throws {
        // Setup mock results
        let mockResults = createMockResults()
        mockQuizStorageService.mockResults = mockResults
        
        // Test loading results
        viewModel.loadResults()
        
        XCTAssertEqual(viewModel.recentResults.count, 3)
        XCTAssertEqual(viewModel.totalQuizzes, 3)
        XCTAssertEqual(viewModel.averageScore, 73) // (80 + 70 + 70) / 3 = 73
        XCTAssertTrue(viewModel.hasResult)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testResultsViewModelLoadResultsEmpty() throws {
        // Setup empty results
        mockQuizStorageService.mockResults = []
        
        // Test loading empty results
        viewModel.loadResults()
        
        XCTAssertTrue(viewModel.recentResults.isEmpty)
        XCTAssertEqual(viewModel.totalQuizzes, 0)
        XCTAssertEqual(viewModel.averageScore, 0)
        XCTAssertFalse(viewModel.hasResult)
    }
    
    func testResultsViewModelSaveResult() throws {
        // Setup initial state with some results
        let initialResults = createMockResults()
        mockQuizStorageService.mockResults = initialResults
        viewModel.loadResults()
        
        let initialCount = viewModel.recentResults.count
        let initialTotalQuizzes = viewModel.totalQuizzes
        let initialAverageScore = viewModel.averageScore
        
        // Create and save new result
        let newResult = QuizResult(
            userName: "New User",
            score: 90,
            correctAnswers: 9,
            totalQuestions: 10
        )
        
        viewModel.saveResult(newResult)
        
        // Verify new result is added at the beginning
        XCTAssertEqual(viewModel.recentResults.count, initialCount + 1)
        XCTAssertEqual(viewModel.recentResults.first?.userName, "New User")
        XCTAssertEqual(viewModel.recentResults.first?.score, 90)
        
        // Verify statistics are updated
        XCTAssertEqual(viewModel.totalQuizzes, initialTotalQuizzes + 1)
        XCTAssertNotEqual(viewModel.averageScore, initialAverageScore)
    }
    
    func testResultsViewModelSaveResultToEmptyList() throws {
        // Ensure empty state
        mockQuizStorageService.mockResults = []
        viewModel.loadResults()
        
        // Save first result
        let firstResult = QuizResult(
            userName: "First User",
            score: 100,
            correctAnswers: 10,
            totalQuestions: 10
        )
        
        viewModel.saveResult(firstResult)
        
        XCTAssertEqual(viewModel.recentResults.count, 1)
        XCTAssertEqual(viewModel.totalQuizzes, 1)
        XCTAssertEqual(viewModel.averageScore, 100)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelRefreshResults() throws {
        // Setup initial state
        let initialResults = createMockResults()
        mockQuizStorageService.mockResults = initialResults
        viewModel.loadResults()
        
        let initialCount = viewModel.recentResults.count
        
        // Change mock results
        let newResults = [
            QuizResult(userName: "Updated User", score: 95, correctAnswers: 9, totalQuestions: 10)
        ]
        mockQuizStorageService.mockResults = newResults
        
        // Refresh results
        viewModel.refreshResults()
        
        // Verify results are updated
        XCTAssertEqual(viewModel.recentResults.count, 1)
        XCTAssertEqual(viewModel.totalQuizzes, 1)
        XCTAssertEqual(viewModel.averageScore, 95)
        XCTAssertEqual(viewModel.recentResults.first?.userName, "Updated User")
    }
    
    func testResultsViewModelStatisticsCalculation() throws {
        // Test various score combinations
        let testCases = [
            ([QuizResult(userName: "User1", score: 100, correctAnswers: 10, totalQuestions: 10)], 100),
            ([QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10),
              QuizResult(userName: "User2", score: 60, correctAnswers: 6, totalQuestions: 10)], 70),
            ([QuizResult(userName: "User1", score: 90, correctAnswers: 9, totalQuestions: 10),
              QuizResult(userName: "User2", score: 70, correctAnswers: 7, totalQuestions: 10),
              QuizResult(userName: "User3", score: 50, correctAnswers: 5, totalQuestions: 10)], 70)
        ]
        
        for (results, expectedAverage) in testCases {
            mockQuizStorageService.mockResults = results
            viewModel.loadResults()
            
            XCTAssertEqual(viewModel.totalQuizzes, results.count)
            XCTAssertEqual(viewModel.averageScore, expectedAverage)
            XCTAssertEqual(viewModel.recentResults.count, results.count)
        }
    }
    
    func testResultsViewModelAverageScoreRounding() throws {
        // Test that average score rounds down (integer division)
        let results = [
            QuizResult(userName: "User1", score: 85, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "User2", score: 86, correctAnswers: 8, totalQuestions: 10)
        ]
        
        mockQuizStorageService.mockResults = results
        viewModel.loadResults()
        
        // (85 + 86) / 2 = 85.5, should round down to 85
        XCTAssertEqual(viewModel.averageScore, 85)
    }
    
    func testResultsViewModelHasResultComputedProperty() throws {
        // Test empty state
        mockQuizStorageService.mockResults = []
        viewModel.loadResults()
        XCTAssertFalse(viewModel.hasResult)
        
        // Test with results
        let results = [QuizResult(userName: "User", score: 80, correctAnswers: 8, totalQuestions: 10)]
        mockQuizStorageService.mockResults = results
        viewModel.loadResults()
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelInheritanceFromBaseViewModel() throws {
        // Test that ResultsViewModel inherits from BaseViewModel
        XCTAssertTrue(viewModel is BaseViewModel)
        
        // Test BaseViewModel functionality
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        
        // Test error handling
        let testError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        viewModel.handleError(testError)
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showError)
        
        // Test clearing error
        viewModel.clearError()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testResultsViewModelResultOrdering() throws {
        // Test that results are maintained in the order they were added
        let results = [
            QuizResult(userName: "First", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "Second", score: 90, correctAnswers: 9, totalQuestions: 10),
            QuizResult(userName: "Third", score: 70, correctAnswers: 7, totalQuestions: 10)
        ]
        
        mockQuizStorageService.mockResults = results
        viewModel.loadResults()
        
        XCTAssertEqual(viewModel.recentResults[0].userName, "First")
        XCTAssertEqual(viewModel.recentResults[1].userName, "Second")
        XCTAssertEqual(viewModel.recentResults[2].userName, "Third")
    }
    
    func testResultsViewModelSaveResultMaintainsOrder() throws {
        // Setup initial results
        let initialResults = [
            QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10)
        ]
        mockQuizStorageService.mockResults = initialResults
        viewModel.loadResults()
        
        // Save new result
        let newResult = QuizResult(userName: "NewUser", score: 100, correctAnswers: 10, totalQuestions: 10)
        viewModel.saveResult(newResult)
        
        // Verify new result is inserted at the beginning
        XCTAssertEqual(viewModel.recentResults[0].userName, "NewUser")
        XCTAssertEqual(viewModel.recentResults[1].userName, "User1")
        XCTAssertEqual(viewModel.recentResults[2].userName, "User2")
    }
    
    // MARK: - Helper Methods
    
    private func createMockResults() -> [QuizResult] {
        return [
            QuizResult(userName: "John Doe", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "Jane Smith", score: 70, correctAnswers: 7, totalQuestions: 10),
            QuizResult(userName: "Bob Johnson", score: 70, correctAnswers: 7, totalQuestions: 10)
        ]
    }
}

// MARK: - Mock Quiz Storage Service
@MainActor
private class MockQuizStorageService: QuizStorageServiceProtocol {
    var mockResults: [QuizResult] = []
    var shouldThrowError = false
    var mockError: Error?
    
    func saveQuizResult(_ result: QuizResult) {
        if shouldThrowError {
            // In a real scenario, this might throw an error
            // For now, we'll just simulate success
        }
        // The mock doesn't actually persist data, just stores it for testing
        mockResults.append(result)
    }
    
    func loadQuizResults() -> [QuizResult] {
        if shouldThrowError {
            // In a real scenario, this might throw an error
            // For now, we'll just return empty array
            return []
        }
        return mockResults
    }
    
    func getTotalQuizzes() -> Int {
        return mockResults.count
    }
    
    func getAverageScore() -> Int {
        guard !mockResults.isEmpty else { return 0 }
        let totalScore = mockResults.reduce(0) { $0 + $1.score }
        return totalScore / mockResults.count
    }
}
