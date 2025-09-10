//
//  MockNetworkService.swift
//  SergioIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import Foundation
@testable import Sergio

// MARK: - Mock Network Service
class MockNetworkService: NetworkServiceProtocol {
    var mockQuestionResponse: String = ""
    var mockAnswerResponse: String = ""
    var shouldThrowError: Bool = false
    var shouldThrowDecodingError: Bool = false
    var mockError: Error = APIError.invalidURL
    var responseDelay: TimeInterval = 0.05 // 50ms default delay
    
    func request<T>(endpoint: String, method: HTTPMethod, body: Data?, queryItems: [URLQueryItem]?, responseType: T.Type) async throws -> T where T : Decodable, T : Encodable {
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(responseDelay * 1_000_000_000))
        
        // Check if we should throw an error
        if shouldThrowError {
            throw mockError
        }
        
        // Return appropriate mock response based on endpoint
        let jsonString: String
        if endpoint.contains("question") || endpoint.contains("random-question") || endpoint.contains("api.php") {
            jsonString = mockQuestionResponse.isEmpty ? TestDataFactory.createValidQuestion() : mockQuestionResponse
        } else if endpoint.contains("answer") || endpoint.contains("submit-answer") {
            jsonString = mockAnswerResponse.isEmpty ? TestDataFactory.createValidAnswerResponse() : mockAnswerResponse
        } else {
            throw APIError.invalidURL
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            throw APIError.decodingError(NSError(domain: "MockError", code: 1, userInfo: nil))
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            if shouldThrowDecodingError {
                throw APIError.decodingError(error)
            } else {
                throw APIError.decodingError(error)
            }
        }
    }
}
