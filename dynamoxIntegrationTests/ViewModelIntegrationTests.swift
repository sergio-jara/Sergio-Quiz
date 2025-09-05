//
//  ViewModelIntegrationTests.swift
//  dynamoxIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import dynamox

@MainActor
final class ViewModelIntegrationTests: IntegrationTestBase {
    
    // MARK: - QuizViewModel Integration Tests
    
    func testQuizViewModelIntegration() async throws {
        // Given: Mock network service with valid responses
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.mockAnswerResponse = TestDataFactory.createValidAnswerResponse()
        
        // When: Creating and using QuizViewModel with real services
        let viewModel = QuizViewModel(apiClient: apiClient, quizStorageService: storageService)
        
        // Start quiz (this will automatically load the first question)
        viewModel.startQuiz(with: "Integration Test User")
        XCTAssertEqual(viewModel.userName, "Integration Test User")
        
        // Wait for the async task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Verify the integration works correctly
        XCTAssertNotNil(viewModel.currentQuestion)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.currentQuestionNumber, 0) // Should be 0 initially
        
        // Select and submit answer
        viewModel.selectAnswer("4")
        await viewModel.submitAnswer()
        
        // Verify answer submission
        XCTAssertTrue(viewModel.isAnswerSubmitted)
        XCTAssertTrue(viewModel.isAnswerCorrect)
        XCTAssertEqual(viewModel.correctAnswers, 1)
    }
    
    func testQuizViewModelErrorHandlingIntegration() async throws {
        // Given: Mock network service configured to throw errors
        mockNetworkService.shouldThrowError = true
        mockNetworkService.mockError = APIError.invalidURL
        
        // When: Creating QuizViewModel and attempting operations
        let viewModel = QuizViewModel(apiClient: apiClient, quizStorageService: storageService)
        viewModel.startQuiz(with: "Test User")
        
        await viewModel.loadRandomQuestion()
        
        // Then: Verify error handling
        XCTAssertNil(viewModel.currentQuestion)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testQuizViewModelCompleteFlowIntegration() async throws {
        // Given: Mock network service with valid responses
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.mockAnswerResponse = TestDataFactory.createValidAnswerResponse()
        
        // When: Completing a full quiz flow
        let viewModel = QuizViewModel(apiClient: apiClient, quizStorageService: storageService)
        
        // Start quiz (this loads the first question)
        viewModel.startQuiz(with: "Complete Flow Test")
        
        // Wait for first question to load
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Complete multiple questions
        for i in 0..<3 {
            // Answer the current question
            viewModel.selectAnswer("4")
            await viewModel.submitAnswer()
            
            // Verify answer was submitted
            XCTAssertTrue(viewModel.isAnswerSubmitted)
            
            // Move to next question (this will load the next question)
            viewModel.nextQuestion()
            
            // Wait for next question to load
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
        
        // Then: Verify the complete flow works
        XCTAssertEqual(viewModel.correctAnswers, 3)
        XCTAssertEqual(viewModel.currentQuestionNumber, 3)
        // Note: isAnswerSubmitted might be false after nextQuestion() is called
        // as it resets the quiz state
    }
    
    // MARK: - ResultsViewModel Integration Tests
    
    func testResultsViewModelIntegration() throws {
        // Given: Quiz results in storage
        let initialCount = storageService.loadQuizResults().count
        let result1 = QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10)
        let result2 = QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10)
        
        storageService.saveQuizResult(result1)
        storageService.saveQuizResult(result2)
        
        // When: Creating and using ResultsViewModel
        let viewModel = ResultsViewModel(quizStorageService: storageService)
        viewModel.loadResults()
        
        // Then: Verify the integration works correctly
        XCTAssertEqual(viewModel.recentResults.count, initialCount + 2)
        XCTAssertEqual(viewModel.totalQuizzes, initialCount + 2)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelEmptyStateIntegration() throws {
        // Given: Storage with existing data (from previous tests)
        let existingCount = storageService.loadQuizResults().count
        
        // When: Creating ResultsViewModel with storage
        let viewModel = ResultsViewModel(quizStorageService: storageService)
        viewModel.loadResults()
        
        // Then: Verify state handling
        XCTAssertEqual(viewModel.recentResults.count, existingCount)
        XCTAssertEqual(viewModel.totalQuizzes, existingCount)
        if existingCount > 0 {
            XCTAssertTrue(viewModel.hasResult)
        } else {
            XCTAssertFalse(viewModel.hasResult)
        }
    }
    
    func testResultsViewModelSaveResultIntegration() throws {
        // Given: ResultsViewModel with some existing results
        let initialCount = storageService.loadQuizResults().count
        let existingResult = QuizResult(userName: "Existing User", score: 70, correctAnswers: 7, totalQuestions: 10)
        storageService.saveQuizResult(existingResult)
        
        let viewModel = ResultsViewModel(quizStorageService: storageService)
        viewModel.loadResults()
        
        // When: Saving a new result
        let newResult = QuizResult(userName: "New User", score: 95, correctAnswers: 9, totalQuestions: 10)
        viewModel.saveResult(newResult)
        
        // Then: Verify the new result is added
        XCTAssertEqual(viewModel.recentResults.count, initialCount + 2)
        XCTAssertEqual(viewModel.totalQuizzes, initialCount + 2)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelRefreshIntegration() throws {
        // Given: ResultsViewModel with initial results
        let initialCount = storageService.loadQuizResults().count
        let initialResult = QuizResult(userName: "Initial User", score: 80, correctAnswers: 8, totalQuestions: 10)
        storageService.saveQuizResult(initialResult)
        
        let viewModel = ResultsViewModel(quizStorageService: storageService)
        viewModel.loadResults()
        
        // When: Adding more results and refreshing
        let additionalResult = QuizResult(userName: "Additional User", score: 90, correctAnswers: 9, totalQuestions: 10)
        storageService.saveQuizResult(additionalResult)
        viewModel.refreshResults()
        
        // Then: Verify refresh works correctly
        XCTAssertEqual(viewModel.recentResults.count, initialCount + 2)
        XCTAssertEqual(viewModel.totalQuizzes, initialCount + 2)
    }
    
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
    
    // MARK: - Cross-ViewModel Integration Tests
    
    func testQuizToResultsIntegration() async throws {
        // Given: Mock network service and complete quiz flow
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.mockAnswerResponse = TestDataFactory.createValidAnswerResponse()
        
        let quizViewModel = QuizViewModel(apiClient: apiClient, quizStorageService: storageService)
        let resultsViewModel = ResultsViewModel(quizStorageService: storageService)
        
        // When: Completing a quiz and checking results
        quizViewModel.startQuiz(with: "Cross Integration Test")
        
        // Wait for first question to load
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Complete one question
        quizViewModel.selectAnswer("4")
        await quizViewModel.submitAnswer()
        
        // Simulate quiz completion and save result
        let quizResult = QuizResult(
            userName: "Cross Integration Test",
            score: 100,
            correctAnswers: 1,
            totalQuestions: 1
        )
        
        // Save result through the view model (this now saves to storage)
        resultsViewModel.saveResult(quizResult)
        
        // Then: Verify cross-viewmodel integration
        XCTAssertTrue(resultsViewModel.hasResult)
        
        // Check that our specific result was added
        XCTAssertTrue(resultsViewModel.recentResults.contains { $0.userName == "Cross Integration Test" })
        
        // Verify the result has correct data
        if let ourResult = resultsViewModel.recentResults.first(where: { $0.userName == "Cross Integration Test" }) {
            XCTAssertEqual(ourResult.score, 100)
            XCTAssertEqual(ourResult.correctAnswers, 1)
            XCTAssertEqual(ourResult.totalQuestions, 1)
        }
    }
}
