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
    
    // MARK: - Mock Dependencies for Integration Tests
    
    private var mockStartQuizUseCase: MockStartQuizUseCase!
    private var mockLoadNextQuestionUseCase: MockLoadNextQuestionUseCase!
    private var mockSubmitAnswerUseCase: MockSubmitAnswerUseCase!
    private var mockCompleteQuizUseCase: MockCompleteQuizUseCase!
    private var mockScoreCalculationService: MockScoreCalculationService!
    private var mockQuizRepository: MockQuizRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create mock use cases
        mockStartQuizUseCase = MockStartQuizUseCase()
        mockLoadNextQuestionUseCase = MockLoadNextQuestionUseCase()
        mockSubmitAnswerUseCase = MockSubmitAnswerUseCase()
        mockCompleteQuizUseCase = MockCompleteQuizUseCase()
        mockScoreCalculationService = MockScoreCalculationService()
        mockQuizRepository = MockQuizRepository()
    }
    
    override func tearDownWithError() throws {
        mockStartQuizUseCase = nil
        mockLoadNextQuestionUseCase = nil
        mockSubmitAnswerUseCase = nil
        mockCompleteQuizUseCase = nil
        mockScoreCalculationService = nil
        mockQuizRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - QuizViewModel Integration Tests
    
    func testQuizViewModelIntegration() async throws {
        // Given: Mock use cases with valid responses
        mockStartQuizUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockLoadNextQuestionUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockSubmitAnswerUseCase.mockResult = true
        
        // When: Creating and using QuizViewModel with mock use cases
        let viewModel = QuizViewModel(
            startQuizUseCase: mockStartQuizUseCase,
            loadNextQuestionUseCase: mockLoadNextQuestionUseCase,
            submitAnswerUseCase: mockSubmitAnswerUseCase,
            completeQuizUseCase: mockCompleteQuizUseCase,
            scoreCalculationService: mockScoreCalculationService
        )
        
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
        // Given: Mock use cases configured to throw errors
        mockStartQuizUseCase.shouldThrowError = true
        mockStartQuizUseCase.mockError = QuizError.invalidUserName
        
        // When: Creating QuizViewModel and attempting operations
        let viewModel = QuizViewModel(
            startQuizUseCase: mockStartQuizUseCase,
            loadNextQuestionUseCase: mockLoadNextQuestionUseCase,
            submitAnswerUseCase: mockSubmitAnswerUseCase,
            completeQuizUseCase: mockCompleteQuizUseCase,
            scoreCalculationService: mockScoreCalculationService
        )
        viewModel.startQuiz(with: "Test User")
        
        await viewModel.loadRandomQuestion()
        
        // Then: Verify error handling
        XCTAssertNil(viewModel.currentQuestion)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testQuizViewModelCompleteFlowIntegration() async throws {
        // Given: Mock use cases with valid responses
        mockStartQuizUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockLoadNextQuestionUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockSubmitAnswerUseCase.mockResult = true
        
        // When: Completing a full quiz flow
        let viewModel = QuizViewModel(
            startQuizUseCase: mockStartQuizUseCase,
            loadNextQuestionUseCase: mockLoadNextQuestionUseCase,
            submitAnswerUseCase: mockSubmitAnswerUseCase,
            completeQuizUseCase: mockCompleteQuizUseCase,
            scoreCalculationService: mockScoreCalculationService
        )
        
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
    
    func testResultsViewModelIntegration() async throws {
        // Given: Quiz results in mock repository
        let result1 = QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10)
        let result2 = QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10)
        
        mockQuizRepository.mockResults = [result1, result2]
        
        // When: Creating and using ResultsViewModel
        let viewModel = ResultsViewModel(quizRepository: mockQuizRepository)
        await viewModel.loadResults()
        
        // Then: Verify the integration works correctly
        XCTAssertEqual(viewModel.recentResults.count, 2)
        XCTAssertEqual(viewModel.totalQuizzes, 2)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelEmptyStateIntegration() async throws {
        // Given: Empty mock repository
        mockQuizRepository.mockResults = []
        
        // When: Creating ResultsViewModel with storage
        let viewModel = ResultsViewModel(quizRepository: mockQuizRepository)
        await viewModel.loadResults()
        
        // Then: Verify state handling
        XCTAssertEqual(viewModel.recentResults.count, 0)
        XCTAssertEqual(viewModel.totalQuizzes, 0)
        XCTAssertFalse(viewModel.hasResult)
    }
    
    func testResultsViewModelSaveResultIntegration() async throws {
        // Given: ResultsViewModel with some existing results
        let existingResult = QuizResult(userName: "Existing User", score: 70, correctAnswers: 7, totalQuestions: 10)
        mockQuizRepository.mockResults = [existingResult]
        
        let viewModel = ResultsViewModel(quizRepository: mockQuizRepository)
        await viewModel.loadResults()
        
        // When: Saving a new result
        let newResult = QuizResult(userName: "New User", score: 95, correctAnswers: 9, totalQuestions: 10)
        await viewModel.saveResult(newResult)
        
        // Then: Verify the new result is added
        XCTAssertEqual(viewModel.recentResults.count, 2)
        XCTAssertEqual(viewModel.totalQuizzes, 2)
        XCTAssertTrue(viewModel.hasResult)
    }
    
    func testResultsViewModelRefreshIntegration() async throws {
        // Given: ResultsViewModel with initial results
        let initialResult = QuizResult(userName: "Initial User", score: 80, correctAnswers: 8, totalQuestions: 10)
        mockQuizRepository.mockResults = [initialResult]
        
        let viewModel = ResultsViewModel(quizRepository: mockQuizRepository)
        await viewModel.loadResults()
        
        // When: Adding more results and refreshing
        let additionalResult = QuizResult(userName: "Additional User", score: 90, correctAnswers: 9, totalQuestions: 10)
        mockQuizRepository.mockResults = [initialResult, additionalResult]
        await viewModel.refreshResults()
        
        // Then: Verify refresh works correctly
        XCTAssertEqual(viewModel.recentResults.count, 2)
        XCTAssertEqual(viewModel.totalQuizzes, 2)
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
        // Given: Mock use cases and repository
        mockStartQuizUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockLoadNextQuestionUseCase.mockQuestion = TestDataFactory.createValidQuestionObject()
        mockSubmitAnswerUseCase.mockResult = true
        
        let quizViewModel = QuizViewModel(
            startQuizUseCase: mockStartQuizUseCase,
            loadNextQuestionUseCase: mockLoadNextQuestionUseCase,
            submitAnswerUseCase: mockSubmitAnswerUseCase,
            completeQuizUseCase: mockCompleteQuizUseCase,
            scoreCalculationService: mockScoreCalculationService
        )
        let resultsViewModel = ResultsViewModel(quizRepository: mockQuizRepository)
        
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
        await resultsViewModel.saveResult(quizResult)
        
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

// MARK: - Mock Classes for Integration Tests

@MainActor
private class MockStartQuizUseCase: StartQuizUseCaseProtocol {
    var mockQuestion: QuizQuestion?
    var shouldThrowError = false
    var mockError: Error?

    func execute(userName: String) async throws -> QuizQuestion {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockQuestion ?? QuizQuestion(id: "mock", statement: "Mock question?", options: ["A", "B", "C", "D"])
    }
}

@MainActor
private class MockLoadNextQuestionUseCase: LoadNextQuestionUseCaseProtocol {
    var mockQuestion: QuizQuestion?
    var shouldThrowError = false
    var mockError: Error?

    func execute() async throws -> QuizQuestion {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockQuestion ?? QuizQuestion(id: "mock", statement: "Mock question?", options: ["A", "B", "C", "D"])
    }
}

@MainActor
private class MockSubmitAnswerUseCase: SubmitAnswerUseCaseProtocol {
    var mockResult: Bool = true
    var shouldThrowError = false
    var mockError: Error?

    func execute(questionId: String, answer: String) async throws -> Bool {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockResult
    }
}

@MainActor
private class MockCompleteQuizUseCase: CompleteQuizUseCaseProtocol {
    var mockResult: QuizResult?
    var shouldThrowError = false
    var mockError: Error?

    func execute(userName: String, correctAnswers: Int, totalQuestions: Int) async throws -> QuizResult {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockResult ?? QuizResult(userName: userName, score: 100, correctAnswers: correctAnswers, totalQuestions: totalQuestions)
    }
}

@MainActor
private class MockScoreCalculationService: ScoreCalculationServiceProtocol {
    nonisolated(unsafe) var mockPerformanceLevel: PerformanceLevel = .good
    
    nonisolated func calculateScore(correctAnswers: Int, totalQuestions: Int) -> Int {
        guard totalQuestions > 0 else { return 0 }
        return Int(Double(correctAnswers) / Double(totalQuestions) * 100)
    }
    
    nonisolated func evaluatePerformance(score: Int) -> PerformanceLevel {
        return mockPerformanceLevel
    }
}

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
