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
    private var mockStartQuizUseCase: MockStartQuizUseCase!
    private var mockLoadNextQuestionUseCase: MockLoadNextQuestionUseCase!
    private var mockSubmitAnswerUseCase: MockSubmitAnswerUseCase!
    private var mockCompleteQuizUseCase: MockCompleteQuizUseCase!
    private var mockScoreCalculationService: MockScoreCalculationService!
    private var viewModel: QuizViewModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        mockStartQuizUseCase = MockStartQuizUseCase()
        mockLoadNextQuestionUseCase = MockLoadNextQuestionUseCase()
        mockSubmitAnswerUseCase = MockSubmitAnswerUseCase()
        mockCompleteQuizUseCase = MockCompleteQuizUseCase()
        mockScoreCalculationService = MockScoreCalculationService()
        
        viewModel = QuizViewModel(
            startQuizUseCase: mockStartQuizUseCase,
            loadNextQuestionUseCase: mockLoadNextQuestionUseCase,
            submitAnswerUseCase: mockSubmitAnswerUseCase,
            completeQuizUseCase: mockCompleteQuizUseCase,
            scoreCalculationService: mockScoreCalculationService
        )
    }
    
    override func tearDownWithError() throws {
        mockStartQuizUseCase = nil
        mockLoadNextQuestionUseCase = nil
        mockSubmitAnswerUseCase = nil
        mockCompleteQuizUseCase = nil
        mockScoreCalculationService = nil
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
    
    func testQuizViewModelStartQuiz() async throws {
        // Setup mock question
        let mockQuestion = QuizQuestion(
            id: "test-id",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
        mockStartQuizUseCase.mockQuestion = mockQuestion
        mockStartQuizUseCase.shouldThrowError = false
        
        // Test starting quiz with user name
        viewModel.startQuiz(with: "John")
        
        // Wait for async operation to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertEqual(viewModel.userName, "John")
        XCTAssertEqual(viewModel.currentQuestion?.id, mockQuestion.id)
        XCTAssertFalse(viewModel.isLoading)
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
        mockLoadNextQuestionUseCase.mockQuestion = mockQuestion
        mockLoadNextQuestionUseCase.shouldThrowError = false
        
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
        mockLoadNextQuestionUseCase.shouldThrowError = true
        mockLoadNextQuestionUseCase.mockError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
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
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "4"
        mockSubmitAnswerUseCase.mockIsCorrect = true
        mockSubmitAnswerUseCase.shouldThrowError = false
        
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
        
        viewModel.currentQuestion = mockQuestion
        viewModel.selectedAnswer = "3"
        mockSubmitAnswerUseCase.mockIsCorrect = false
        mockSubmitAnswerUseCase.shouldThrowError = false
        
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
        mockSubmitAnswerUseCase.shouldThrowError = true
        mockSubmitAnswerUseCase.mockError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Submission error"])
        
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
        mockLoadNextQuestionUseCase.mockQuestion = mockQuestion
        mockLoadNextQuestionUseCase.shouldThrowError = false
        
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
        mockLoadNextQuestionUseCase.mockQuestion = mockQuestion
        mockLoadNextQuestionUseCase.shouldThrowError = false
        
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
        
        // Test score message for different ranges using mock service
        viewModel.correctAnswers = 9 // 90%
        mockScoreCalculationService.mockPerformanceLevel = .excellent
        XCTAssertEqual(viewModel.scoreMessage, "Excelente! Você é um mestre do quiz!")
        
        viewModel.correctAnswers = 8 // 80%
        mockScoreCalculationService.mockPerformanceLevel = .great
        XCTAssertEqual(viewModel.scoreMessage, "Ótimo trabalho! Você sabe das coisas!")
        
        viewModel.correctAnswers = 6 // 60%
        mockScoreCalculationService.mockPerformanceLevel = .good
        XCTAssertEqual(viewModel.scoreMessage, "Bom esforço! Continue aprendendo!")
        
        viewModel.correctAnswers = 4 // 40%
        mockScoreCalculationService.mockPerformanceLevel = .fair
        XCTAssertEqual(viewModel.scoreMessage, "Nada mal! Há espaço para melhorar!")
        
        viewModel.correctAnswers = 2 // 20%
        mockScoreCalculationService.mockPerformanceLevel = .poor
        XCTAssertEqual(viewModel.scoreMessage, "Continue praticando! Você vai melhorar!")
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

// MARK: - Mock Use Cases and Services

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
    var mockIsCorrect: Bool = true
    var shouldThrowError = false
    var mockError: Error?
    
    func execute(questionId: String, answer: String) async throws -> Bool {
        if shouldThrowError {
            throw mockError ?? NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockIsCorrect
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
        return mockResult ?? QuizResult(userName: userName, score: 80, correctAnswers: correctAnswers, totalQuestions: totalQuestions)
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
