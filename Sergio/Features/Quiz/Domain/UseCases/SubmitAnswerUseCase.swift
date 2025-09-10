//
//  SubmitAnswerUseCase.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Submit Answer Use Case Protocol
protocol SubmitAnswerUseCaseProtocol {
    func execute(questionId: String, answer: String) async throws -> Bool
}

// MARK: - Submit Answer Use Case Implementation
class SubmitAnswerUseCase: SubmitAnswerUseCaseProtocol {
    private let quizRepository: QuizRepositoryProtocol
    
    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
    }
    
    func execute(questionId: String, answer: String) async throws -> Bool {
        guard !questionId.isEmpty else {
            throw QuizError.invalidQuestionId
        }
        
        guard !answer.isEmpty else {
            throw QuizError.invalidAnswer
        }
        
        return try await quizRepository.submitAnswer(questionId: questionId, answer: answer)
    }
}
