//
//  QuizAPIIntegrationTests.swift
//  dynamoxIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import dynamox

@MainActor
final class QuizAPIIntegrationTests: IntegrationTestBase {
    
    // MARK: - API Integration Tests
    
    func testFetchRandomQuestionIntegration() async throws {
        // Given: Mock network service with valid question response
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        
        // When: Fetching a question through the integration
        let question = try await apiClient.fetchRandomQuestion()
        
        // Then: Verify the integration works correctly
        validateQuestionStructure(question)
        XCTAssertTrue(question.statement.hasSuffix("?"), "Question should end with a question mark")
    }
    
    func testSubmitAnswerIntegration() async throws {
        // Given: Mock network service with valid responses
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.mockAnswerResponse = TestDataFactory.createValidAnswerResponse()
        
        // When: Submitting an answer through the integration
        let question = try await apiClient.fetchRandomQuestion()
        let response = try await apiClient.submitAnswer(
            questionId: question.id,
            answer: question.options.first!
        )
        
        // Then: Verify the integration works correctly
        validateAnswerResponse(response)
        XCTAssertTrue(response.result == true)
    }
    
    func testSubmitAnswerIncorrectIntegration() async throws {
        // Given: Mock network service with incorrect answer response
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.mockAnswerResponse = TestDataFactory.createInvalidAnswerResponse()
        
        // When: Submitting an incorrect answer
        let question = try await apiClient.fetchRandomQuestion()
        let response = try await apiClient.submitAnswer(
            questionId: question.id,
            answer: question.options.first!
        )
        
        // Then: Verify the integration handles incorrect answers
        validateAnswerResponse(response)
        XCTAssertTrue(response.result == false)
    }
    
    func testNetworkErrorHandlingIntegration() async throws {
        // Given: Mock network service configured to throw an error
        mockNetworkService.shouldThrowError = true
        mockNetworkService.mockError = APIError.invalidURL
        
        // When: Attempting to fetch a question with network issues
        await expectAsync({
            try await self.apiClient.fetchRandomQuestion()
        }, toThrow: APIError.invalidURL)
    }
    
    func testDecodingErrorHandlingIntegration() async throws {
        // Given: Mock network service with malformed JSON
        mockNetworkService.mockQuestionResponse = TestDataFactory.createMalformedJSON()
        
        // When: Attempting to fetch a question with malformed JSON
        do {
            _ = try await apiClient.fetchRandomQuestion()
            XCTFail("Should have thrown a decoding error")
        } catch {
            // Then: Verify the integration properly handles decoding errors
            XCTAssertTrue(error is APIError, "Should throw an API error")
        }
    }
    
    func testEmptyResponseHandlingIntegration() async throws {
        // Given: Mock network service with empty response
        mockNetworkService.mockQuestionResponse = TestDataFactory.createEmptyQuestion()
        
        // When: Fetching a question with empty data
        let question = try await apiClient.fetchRandomQuestion()
        
        // Then: Verify the integration handles empty data
        XCTAssertEqual(question.id, "")
        XCTAssertEqual(question.statement, "")
        XCTAssertEqual(question.options.count, 0)
    }
    
    // MARK: - Performance Tests
    
    func testAPIIntegrationPerformance() async throws {
        // Given: Mock network service with fast responses
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        mockNetworkService.responseDelay = 0.01 // 10ms delay
        
        // When: Measuring integration performance
        let (_, executionTime) = try await measureAsync {
            for _ in 0..<10 {
                _ = try await self.apiClient.fetchRandomQuestion()
            }
        }
        
        // Then: Verify integration is performant
        XCTAssertLessThan(executionTime, 1.0, "Integration should complete within 1 second")
    }
    
    // MARK: - Edge Case Tests
    
    func testConcurrentAPICallsIntegration() async throws {
        // Given: Mock network service with valid responses
        mockNetworkService.mockQuestionResponse = TestDataFactory.createValidQuestion()
        
        // When: Making concurrent API calls
        let questions = try await withThrowingTaskGroup(of: QuizQuestion.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    try await self.apiClient.fetchRandomQuestion()
                }
            }
            
            var results: [QuizQuestion] = []
            for try await question in group {
                results.append(question)
            }
            return results
        }
        
        // Then: Verify all calls succeed
        XCTAssertEqual(questions.count, 5)
        for question in questions {
            validateQuestionStructure(question)
        }
    }
    
    func testIntegrationWithRealDataStructures() async throws {
        // Given: Mock network service with realistic quiz data
        mockNetworkService.mockQuestionResponse = TestDataFactory.createRealisticQuestion()
        
        // When: Fetching a question through the integration
        let question = try await apiClient.fetchRandomQuestion()
        
        // Then: Verify the integration works with realistic data
        validateQuestionStructure(question)
        XCTAssertTrue(question.statement.contains("programming language"))
        XCTAssertTrue(question.options.contains("Swift"))
        XCTAssertTrue(question.options.contains("Java"))
    }
}
