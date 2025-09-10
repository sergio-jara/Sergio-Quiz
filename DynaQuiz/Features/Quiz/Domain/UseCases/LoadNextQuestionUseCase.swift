//
//  LoadNextQuestionUseCase.swift
//  DynaQuiz
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Load Next Question Use Case Protocol
protocol LoadNextQuestionUseCaseProtocol {
    func execute() async throws -> QuizQuestion
}

// MARK: - Load Next Question Use Case Implementation
class LoadNextQuestionUseCase: LoadNextQuestionUseCaseProtocol {
    private let quizRepository: QuizRepositoryProtocol
    
    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
    }
    
    func execute() async throws -> QuizQuestion {
        return try await quizRepository.fetchRandomQuestion()
    }
}
