//
//  QuizRepository.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Quiz Repository Implementation
class QuizRepository: QuizRepositoryProtocol {
    private let apiClient: QuizAPIClientProtocol
    private let storageService: QuizStorageServiceProtocol
    
    init(apiClient: QuizAPIClientProtocol, storageService: QuizStorageServiceProtocol) {
        self.apiClient = apiClient
        self.storageService = storageService
    }
    
    // MARK: - API Operations
    func fetchRandomQuestion() async throws -> QuizQuestion {
        return try await apiClient.fetchRandomQuestion()
    }
    
    func submitAnswer(questionId: String, answer: String) async throws -> Bool {
        let response = try await apiClient.submitAnswer(questionId: questionId, answer: answer)
        return response.result
    }
    
    // MARK: - Storage Operations
    func saveQuizResult(_ result: QuizResult) async throws {
        // Run storage operations on background thread
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                self.storageService.saveQuizResult(result)
                continuation.resume()
            }
        }
    }
    
    func loadQuizResults() async throws -> [QuizResult] {
        // Run storage operations on background thread
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let results = self.storageService.loadQuizResults()
                continuation.resume(returning: results)
            }
        }
    }
    
    func getTotalQuizzes() async throws -> Int {
        // Run storage operations on background thread
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let total = self.storageService.getTotalQuizzes()
                continuation.resume(returning: total)
            }
        }
    }
    
    func getAverageScore() async throws -> Int {
        // Run storage operations on background thread
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let average = self.storageService.getAverageScore()
                continuation.resume(returning: average)
            }
        }
    }
}
