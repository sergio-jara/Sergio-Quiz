//
//  ResultsViewModelTests.swift
//  DynaQuizTests
//
//  Created by sergio jara on 25/08/25.
//

import XCTest
@testable import DynaQuiz

@MainActor
final class ResultsViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var mockQuizRepository: MockQuizRepository!
    private var viewModel: ResultsViewModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        mockQuizRepository = MockQuizRepository()
        viewModel = ResultsViewModel(quizRepository: mockQuizRepository)
    }
    
    override func tearDownWithError() throws {
        mockQuizRepository = nil
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
    
    func testResultsViewModelLoadResultsSuccess() async throws {
        // Setup mock results
        let mockResults = createMockResults()
        mockQuizRepository.mockResults = mockResults
        
        // Test loading results
        await viewModel.loadResults()
        
        XCTAssertEqual(viewModel.recentResults.count, 3)
        XCTAssertEqual(viewModel.totalQuizzes, 3)
        XCTAssertEqual(viewModel.averageScore, 73) // (80 + 70 + 70) / 3 = 73
        XCTAssertTrue(viewModel.hasResult)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testResultsViewModelLoadResultsEmpty() async throws {
        // Setup empty results
        mockQuizRepository.mockResults = []
        
        // Test loading empty results
        await viewModel.loadResults()
        
        XCTAssertTrue(viewModel.recentResults.isEmpty)
        XCTAssertEqual(viewModel.totalQuizzes, 0)
        XCTAssertEqual(viewModel.averageScore, 0)
        XCTAssertFalse(viewModel.hasResult)
    }
    
    func testResultsViewModelSaveResult() async throws {
        // Setup initial state with some results
        let initialResults = createMockResults()
        mockQuizRepository.mockResults = initialResults
        await viewModel.loadResults()
        
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
        
        await viewModel.saveResult(newResult)
        
        // Verify new result is added at the beginning
        XCTAssertEqual(viewModel.recentResults.count, initialCount + 1)
        XCTAssertEqual(viewModel.recentResults.first?.userName, "New User")
        XCTAssertEqual(viewModel.recentResults.first?.score, 90)
        
        // Verify statistics are updated
        XCTAssertEqual(viewModel.totalQuizzes, initialTotalQuizzes + 1)
        XCTAssertNotEqual(viewModel.averageScore, initialAverageScore)
    }
    
    func testResultsViewModelSaveResultToEmptyList() async throws {
        // Ensure empty state
        mockQuizRepository.mockResults = []
        await viewModel.loadResults()
        
        // Save first result
        let firstResult = QuizResult(
            userName: "First User",
            score: 100,
            correctAnswers: 10,
            totalQuestions: 10
        )
        
        await viewModel.saveResult(firstResult)
        
        XCTAssertEqual(viewModel.recentResults.count, 1)
        XCTAssertEqual(viewModel.totalQuizzes, 1)
        XCTAssertEqual(viewModel.averageScore, 100)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelRefreshResults() async throws {
        // Setup initial state
        let initialResults = createMockResults()
        mockQuizRepository.mockResults = initialResults
        await viewModel.loadResults()
        
        let initialCount = viewModel.recentResults.count
        
        // Change mock results
        let newResults = [
            QuizResult(userName: "Updated User", score: 95, correctAnswers: 9, totalQuestions: 10)
        ]
        mockQuizRepository.mockResults = newResults
        
        // Refresh results
        viewModel.refreshResults()
        
        // Wait for async operation to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Verify results are updated
        XCTAssertEqual(viewModel.recentResults.count, 1)
        XCTAssertEqual(viewModel.totalQuizzes, 1)
        XCTAssertEqual(viewModel.averageScore, 95)
        XCTAssertEqual(viewModel.recentResults.first?.userName, "Updated User")
    }
    
    func testResultsViewModelStatisticsCalculation() async throws {
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
            mockQuizRepository.mockResults = results
            await viewModel.loadResults()
            
            XCTAssertEqual(viewModel.totalQuizzes, results.count)
            XCTAssertEqual(viewModel.averageScore, expectedAverage)
            XCTAssertEqual(viewModel.recentResults.count, results.count)
        }
    }
    
    func testResultsViewModelAverageScoreRounding() async throws {
        // Test that average score rounds down (integer division)
        let results = [
            QuizResult(userName: "User1", score: 85, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "User2", score: 86, correctAnswers: 8, totalQuestions: 10)
        ]
        
        mockQuizRepository.mockResults = results
        await viewModel.loadResults()
        
        // (85 + 86) / 2 = 85.5, should round down to 85
        XCTAssertEqual(viewModel.averageScore, 85)
    }
    
    func testResultsViewModelHasResultComputedProperty() async throws {
        // Test empty state
        mockQuizRepository.mockResults = []
        await viewModel.loadResults()
        XCTAssertFalse(viewModel.hasResult)
        
        // Test with results
        let results = [QuizResult(userName: "User", score: 80, correctAnswers: 8, totalQuestions: 10)]
        mockQuizRepository.mockResults = results
        await viewModel.loadResults()
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
    
    func testResultsViewModelResultOrdering() async throws {
        // Test that results are maintained in the order they were added
        let results = [
            QuizResult(userName: "First", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "Second", score: 90, correctAnswers: 9, totalQuestions: 10),
            QuizResult(userName: "Third", score: 70, correctAnswers: 7, totalQuestions: 10)
        ]
        
        mockQuizRepository.mockResults = results
        await viewModel.loadResults()
        
        XCTAssertEqual(viewModel.recentResults[0].userName, "First")
        XCTAssertEqual(viewModel.recentResults[1].userName, "Second")
        XCTAssertEqual(viewModel.recentResults[2].userName, "Third")
    }
    
    func testResultsViewModelSaveResultMaintainsOrder() async throws {
        // Setup initial results
        let initialResults = [
            QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10)
        ]
        mockQuizRepository.mockResults = initialResults
        await viewModel.loadResults()
        
        // Save new result
        let newResult = QuizResult(userName: "NewUser", score: 100, correctAnswers: 10, totalQuestions: 10)
        await viewModel.saveResult(newResult)
        
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

// MARK: - Mock Quiz Repository
@MainActor
private class MockQuizRepository: QuizRepositoryProtocol {
    var mockResults: [QuizResult] = []
    var shouldThrowError = false
    var mockError: Error?
    
    func fetchRandomQuestion() async throws -> QuizQuestion {
        throw QuizError.networkUnavailable
    }
    
    func submitAnswer(questionId: String, answer: String) async throws -> Bool {
        throw QuizError.networkUnavailable
    }
    
    func saveQuizResult(_ result: QuizResult) async throws {
        if shouldThrowError {
            throw mockError ?? QuizError.storageError
        }
        mockResults.append(result)
    }
    
    func loadQuizResults() async throws -> [QuizResult] {
        if shouldThrowError {
            throw mockError ?? QuizError.storageError
        }
        return mockResults
    }
    
    func getTotalQuizzes() async throws -> Int {
        if shouldThrowError {
            throw mockError ?? QuizError.storageError
        }
        return mockResults.count
    }
    
    func getAverageScore() async throws -> Int {
        if shouldThrowError {
            throw mockError ?? QuizError.storageError
        }
        guard !mockResults.isEmpty else { return 0 }
        let totalScore = mockResults.reduce(0) { $0 + $1.score }
        return totalScore / mockResults.count
    }
}
