//
//  StartQuizUseCase.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Start Quiz Use Case Protocol
protocol StartQuizUseCaseProtocol {
    func execute(userName: String) async throws -> QuizQuestion
}

// MARK: - Start Quiz Use Case Implementation
class StartQuizUseCase: StartQuizUseCaseProtocol {
    private let quizRepository: QuizRepositoryProtocol
    
    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
    }
    
    func execute(userName: String) async throws -> QuizQuestion {
        guard !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw QuizError.invalidUserName
        }
        
        return try await quizRepository.fetchRandomQuestion()
    }
}
