//
//  TestDataFactory.swift
//  SergioIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import Foundation
@testable import Sergio

// MARK: - Test Data Factory
class TestDataFactory {
    
    static func createValidQuestion() -> String {
        return """
        {
            "id": "test-question-\(UUID().uuidString)",
            "statement": "What is 2+2?",
            "options": ["3", "4", "5", "6"]
        }
        """
    }
    
    static func createValidQuestionObject() -> QuizQuestion {
        return QuizQuestion(
            id: "test-question-\(UUID().uuidString)",
            statement: "What is 2+2?",
            options: ["3", "4", "5", "6"]
        )
    }
    
    static func createValidAnswerResponse() -> String {
        return """
        {
            "result": true
        }
        """
    }
    
    static func createInvalidAnswerResponse() -> String {
        return """
        {
            "result": false
        }
        """
    }
    
    static func createMalformedJSON() -> String {
        return """
        {
            "id": "malformed",
            "statement": "Malformed JSON?",
            "options": ["A", "B", "C", "D"
        """
    }
    
    static func createEmptyQuestion() -> String {
        return """
        {
            "id": "",
            "statement": "",
            "options": []
        }
        """
    }
    
    static func createQuizResult() -> QuizResult {
        return QuizResult(
            userName: "Test User",
            score: 85,
            correctAnswers: 8,
            totalQuestions: 10
        )
    }
    
    static func createRealisticQuestion() -> String {
        return """
        {
            "id": "realistic-question-123",
            "statement": "Which programming language is used for iOS development?",
            "options": ["Java", "Swift", "Python", "C++"]
        }
        """
    }
    
    static func createMultipleQuizResults() -> [QuizResult] {
        return [
            QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10),
            QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10),
            QuizResult(userName: "User3", score: 70, correctAnswers: 7, totalQuestions: 10)
        ]
    }
}
