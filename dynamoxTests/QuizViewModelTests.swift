//
//  QuizViewModelTests.swift
//  dynamoxTests
//
//  Created by sergio jara on 24/08/25.
//

import XCTest
@testable import dynamox

@MainActor
final class QuizViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var mockAPIClient: MockQuizAPIClient!
    private var viewModel: QuizViewModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        mockAPIClient = MockQuizAPIClient()
        viewModel = QuizViewModel(apiClient: mockAPIClient)
    }
    
    override func tearDownWithError() throws {
        mockAPIClient = nil
        viewModel = nil
    }
    
    // MARK: - QuizViewModel Tests
    
    func testQuizViewModelInitialState() throws {
        // Test initial state
        XCTAssertNil(viewModel.currentQuestion)
        XCTAssertEqual(viewModel.selectedAnswer, "")
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertFalse(viewModel.isAnswerCorrect)
        XCTAssertEqual(viewModel.currentQuestionNumber, 0)
        XCTAssertEqual(viewModel.correctAnswers, 0)
        XCTAssertFalse(viewModel.isQuizCompleted)
        XCTAssertEqual(viewModel.userName, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.totalQuestions, 10)
    }
    
    func testQuizViewModelStartQuiz() throws {
        // Test starting quiz with user name
        viewModel.startQuiz(with: "John")
        
        XCTAssertEqual(viewModel.userName, "John")
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testQuizViewModelLoadRandomQuestionSuccess() async throws {
        // Setup mock response
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        mockAPIClient.mockQuestion = mockQuestion
        mockAPIClient.shouldThrowError = false
        
        // Test loading question
        await viewModel.loadRandomQuestion()
        
        XCTAssertEqual(viewModel.currentQuestion?.id, mockQuestion.id)
        XCTAssertEqual(viewModel.currentQuestion?.statement, mockQuestion.statement)
        XCTAssertEqual(viewModel.currentQuestion?.options, mockQuestion.options)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.selectedAnswer, "")
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertFalse(viewModel.isAnswerCorrect)
    }
    
    func testQuizViewModelLoadRandomQuestionFailure() async throws {
        // Setup mock to throw error
        mockAPIClient.shouldThrowError = true
        mockAPIClient.mockError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        // Test loading question with error
        await viewModel.loadRandomQuestion()
        
        XCTAssertNil(viewModel.currentQuestion)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testQuizViewModelLoadRandomQuestionQuizCompleted() async throws {
        // Set question number to total questions
        viewModel.currentQuestionNumber = 10
        
        // Test loading question when quiz is completed
        await viewModel.loadRandomQuestion()
        
        XCTAssertTrue(viewModel.isQuizCompleted)
        XCTAssertNil(viewModel.currentQuestion)
    }
    
    func testQuizViewModelSubmitAnswerSuccess() async throws {
        // Setup mock question and response
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        let mockResponse = QuizAnswerResponse(result: true)
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "4"
        mockAPIClient.mockAnswerResponse = mockResponse
        mockAPIClient.shouldThrowError = false
        
        // Test submitting answer
        await viewModel.submitAnswer()
        
        XCTAssertTrue(viewModel.isAnswerCorrect)
        XCTAssertTrue(viewModel.isAnswerSubmitted)
        XCTAssertEqual(viewModel.correctAnswers, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testQuizViewModelSubmitAnswerIncorrect() async throws {
        // Setup mock question and response
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        let mockResponse = QuizAnswerResponse(result: false)
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "3"
        mockAPIClient.mockAnswerResponse = mockResponse
        mockAPIClient.shouldThrowError = false
        
        // Test submitting incorrect answer
        await viewModel.submitAnswer()
        
        XCTAssertFalse(viewModel.isAnswerCorrect)
        XCTAssertTrue(viewModel.isAnswerSubmitted)
        XCTAssertEqual(viewModel.correctAnswers, 0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testQuizViewModelSubmitAnswerFailure() async throws {
        // Setup mock question and error
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "4"
        mockAPIClient.shouldThrowError = true
        mockAPIClient.mockError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Submission error"])
        
        // Test submitting answer with error
        await viewModel.submitAnswer()
        
        XCTAssertFalse(viewModel.isAnswerCorrect)
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertEqual(viewModel.correctAnswers, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testQuizViewModelSubmitAnswerNoQuestion() async throws {
        // Test submitting answer without question
        viewModel.selectedAnswer = "4"
        
        await viewModel.submitAnswer()
        
        XCTAssertFalse(viewModel.isAnswerCorrect)
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertEqual(viewModel.correctAnswers, 0)
    }
    
    func testQuizViewModelSubmitAnswerEmptyAnswer() async throws {
        // Setup mock question
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = ""
        
        // Test submitting empty answer
        await viewModel.submitAnswer()
        
        XCTAssertFalse(viewModel.isAnswerCorrect)
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertEqual(viewModel.correctAnswers, 0)
    }
    
    func testQuizViewModelSelectAnswer() throws {
        // Test selecting answer
        viewModel.selectAnswer("Option A")
        
        XCTAssertEqual(viewModel.selectedAnswer, "Option A")
    }
    
    func testQuizViewModelNextQuestion() async throws {
        // Setup mock question
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        mockAPIClient.mockQuestion = mockQuestion
        mockAPIClient.shouldThrowError = false
        
        // Test moving to next question
        viewModel.currentQuestionNumber = 0
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "4"
        viewModel.isAnswerSubmitted = true
        
        viewModel.nextQuestion()
        
        // Verify question number increased
        XCTAssertEqual(viewModel.currentQuestionNumber, 1)
        
        // Wait for the async loadRandomQuestion to complete
        // The state will be reset when the new question loads
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Now verify the state has been reset
        XCTAssertEqual(viewModel.selectedAnswer, "")
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertFalse(viewModel.isAnswerCorrect)
    }
    
    func testQuizViewModelNextQuestionQuizCompleted() async throws {
        // Setup to trigger quiz completion
        viewModel.currentQuestionNumber = 9
        
        // Test moving to next question when quiz is completed
        viewModel.nextQuestion()
        
        XCTAssertEqual(viewModel.currentQuestionNumber, 10)
        XCTAssertTrue(viewModel.isQuizCompleted)
    }
    
    func testQuizViewModelRestartQuiz() async throws {
        // Setup quiz state
        viewModel.currentQuestionNumber = 5
        viewModel.correctAnswers = 3
        viewModel.isQuizCompleted = true
        viewModel.currentQuestion = QuizQuestion(id: "test", statement: "Test", options: ["A", "B"])
        viewModel.selectedAnswer = "A"
        viewModel.isAnswerSubmitted = true
        viewModel.isAnswerCorrect = true
        
        // Setup mock for new question
        let mockQuestion = QuizQuestion(
            id: "new-id",
            statement: "New question?",
            options: ["Yes", "No"]
        )
        mockAPIClient.mockQuestion = mockQuestion
        mockAPIClient.shouldThrowError = false
        
        // Test restarting quiz
        viewModel.restartQuiz()
        
        XCTAssertEqual(viewModel.currentQuestionNumber, 0)
        XCTAssertEqual(viewModel.correctAnswers, 0)
        XCTAssertFalse(viewModel.isQuizCompleted)
        XCTAssertNil(viewModel.currentQuestion)
        XCTAssertEqual(viewModel.selectedAnswer, "")
        XCTAssertFalse(viewModel.isAnswerSubmitted)
        XCTAssertFalse(viewModel.isAnswerCorrect)
    }
    
    func testQuizViewModelComputedProperties() throws {
        // Test score text
        viewModel.correctAnswers = 7
        XCTAssertEqual(viewModel.scoreText, "7/10")
        
        // Test percentage score
        XCTAssertEqual(viewModel.percentageScore, 70.0)
        
        // Test score message for different ranges
        viewModel.correctAnswers = 9 // 90%
        XCTAssertEqual(viewModel.scoreMessage, DesignSystem.Text.Results.excellentScore)
        
        viewModel.correctAnswers = 8 // 80%
        XCTAssertEqual(viewModel.scoreMessage, DesignSystem.Text.Results.greatScore)
        
        viewModel.correctAnswers = 6 // 60%
        XCTAssertEqual(viewModel.scoreMessage, DesignSystem.Text.Results.goodScore)
        
        viewModel.correctAnswers = 4 // 40%
        XCTAssertEqual(viewModel.scoreMessage, DesignSystem.Text.Results.fairScore)
        
        viewModel.correctAnswers = 2 // 20%
        XCTAssertEqual(viewModel.scoreMessage, DesignSystem.Text.Results.poorScore)
    }
    
    func testQuizViewModelInheritanceFromBaseViewModel() throws {
        // Test that QuizViewModel inherits from BaseViewModel
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
}

// MARK: - Mock Quiz API Client
@MainActor
private class MockQuizAPIClient: QuizAPIClientProtocol {
    var mockQuestion: QuizQuestion?
    var mockAnswerResponse: QuizAnswerResponse?
    var shouldThrowError = false
    var mockError: Error?
    
    func fetchRandomQuestion() async throws -> QuizQuestion {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockQuestion ?? QuizQuestion(id: "mock", statement: "Mock question?", options: ["A", "B", "C", "D"])
    }
    
    func submitAnswer(questionId: String, answer: String) async throws -> QuizAnswerResponse {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockAnswerResponse ?? QuizAnswerResponse(result: true)
    }
}
