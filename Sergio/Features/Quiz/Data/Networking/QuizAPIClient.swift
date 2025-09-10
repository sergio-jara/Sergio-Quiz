//
//  QuizAPIClient.swift
//  Sergio
//
//  Created by sergio jara on 24/08/25.
//

import Foundation

// MARK: - Quiz API Client Protocol
protocol QuizAPIClientProtocol {
    func fetchRandomQuestion() async throws -> QuizQuestion
    func submitAnswer(questionId: String, answer: String) async throws -> QuizAnswerResponse
}

// MARK: - Quiz API Client Implementation
class QuizAPIClient: QuizAPIClientProtocol {
    private let networkSErvice: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkSErvice = networkService
    }
    
    func fetchRandomQuestion() async throws -> QuizQuestion {
        return try await networkSErvice.request(endpoint: "/question", method: .GET, body: nil, queryItems: nil, responseType: QuizQuestion.self)
    }
    
    func submitAnswer(questionId: String, answer: String) async throws -> QuizAnswerResponse {
        let requestBody = QuizAnswerRequest(answer: answer)
        let jsonData = try JSONEncoder().encode(requestBody)
        let queryItems = [URLQueryItem(name: "questionId", value: questionId)]
        
        return try await networkSErvice
            .request(
                endpoint: "/answer",
                method: .POST,
                body: jsonData,
                queryItems: queryItems,
                responseType: QuizAnswerResponse.self
            )
    }
}



