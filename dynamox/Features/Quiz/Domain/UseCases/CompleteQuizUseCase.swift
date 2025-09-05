//
//  CompleteQuizUseCase.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Complete Quiz Use Case Protocol
protocol CompleteQuizUseCaseProtocol {
    func execute(userName: String, correctAnswers: Int, totalQuestions: Int) async throws -> QuizResult
}

// MARK: - Complete Quiz Use Case Implementation
class CompleteQuizUseCase: CompleteQuizUseCaseProtocol {
    private let quizRepository: QuizRepositoryProtocol
    private let scoreCalculationService: ScoreCalculationServiceProtocol
    
    init(quizRepository: QuizRepositoryProtocol, scoreCalculationService: ScoreCalculationServiceProtocol) {
        self.quizRepository = quizRepository
        self.scoreCalculationService = scoreCalculationService
    }
    
    func execute(userName: String, correctAnswers: Int, totalQuestions: Int) async throws -> QuizResult {
        guard !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw QuizError.invalidUserName
        }
        
        guard correctAnswers >= 0 && totalQuestions > 0 else {
            throw QuizError.invalidQuizData
        }
        
        let score = scoreCalculationService.calculateScore(correctAnswers: correctAnswers, totalQuestions: totalQuestions)
        
        let result = QuizResult(
            userName: userName,
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            date: Date()
        )
        
        try await quizRepository.saveQuizResult(result)
        return result
    }
}
