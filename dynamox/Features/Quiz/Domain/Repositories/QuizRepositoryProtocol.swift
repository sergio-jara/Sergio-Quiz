//
//  QuizRepositoryProtocol.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Quiz Repository Protocol
protocol QuizRepositoryProtocol {
    func fetchRandomQuestion() async throws -> QuizQuestion
    func submitAnswer(questionId: String, answer: String) async throws -> Bool
    func saveQuizResult(_ result: QuizResult) async throws
    func loadQuizResults() async throws -> [QuizResult]
    func getTotalQuizzes() async throws -> Int
    func getAverageScore() async throws -> Int
}
