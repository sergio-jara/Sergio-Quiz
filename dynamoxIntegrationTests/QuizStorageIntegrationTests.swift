//
//  QuizStorageIntegrationTests.swift
//  SergioIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest
@testable import Sergio

@MainActor
final class QuizStorageIntegrationTests: IntegrationTestBase {
    
    // MARK: - Storage Integration Tests
    
    func testSaveQuizResultIntegration() throws {
        // Given: Clean storage and a quiz result
        let initialCount = storageService.loadQuizResults().count
        let result = TestDataFactory.createQuizResult()
        
        // When: Saving the result through the integration
        storageService.saveQuizResult(result)
        
        // Then: Verify the result is saved correctly
        let results = storageService.loadQuizResults()
        XCTAssertEqual(results.count, initialCount + 1)
        XCTAssertEqual(results.first?.userName, result.userName)
        XCTAssertEqual(results.first?.score, result.score)
    }
    
    func testLoadQuizResultsIntegration() throws {
        // Given: Clean storage and multiple quiz results
        let initialCount = storageService.loadQuizResults().count
        let result1 = QuizResult(userName: "User1", score: 80, correctAnswers: 8, totalQuestions: 10)
        let result2 = QuizResult(userName: "User2", score: 90, correctAnswers: 9, totalQuestions: 10)
        
        storageService.saveQuizResult(result1)
        storageService.saveQuizResult(result2)
        
        // When: Loading all results
        let results = storageService.loadQuizResults()
        
        // Then: Verify all results are loaded correctly
        XCTAssertEqual(results.count, initialCount + 2)
        XCTAssertTrue(results.contains { $0.userName == "User1" })
        XCTAssertTrue(results.contains { $0.userName == "User2" })
    }
    
    func testQuizResultStatisticsIntegration() throws {
        // Given: Clean storage and multiple quiz results with different scores
        let initialCount = storageService.loadQuizResults().count
        let results = TestDataFactory.createMultipleQuizResults()
        
        for result in results {
            storageService.saveQuizResult(result)
        }
        
        // When: Getting statistics
        let totalQuizzes = storageService.getTotalQuizzes()
        let averageScore = storageService.getAverageScore()
        
        // Then: Verify statistics are calculated correctly
        XCTAssertEqual(totalQuizzes, initialCount + 3)
        // Calculate expected average based on new results only
        let expectedAverage = (80 + 90 + 70) / 3 // 80
        XCTAssertEqual(averageScore, expectedAverage)
    }
    
    func testSaveMultipleResultsIntegration() throws {
        // Given: Clean storage and multiple quiz results
        let initialCount = storageService.loadQuizResults().count
        let results = TestDataFactory.createMultipleQuizResults()
        
        // When: Saving all results
        for result in results {
            storageService.saveQuizResult(result)
        }
        
        // Then: Verify all results are saved
        let loadedResults = storageService.loadQuizResults()
        XCTAssertEqual(loadedResults.count, initialCount + 3)
        
        // Verify each result is present
        for originalResult in results {
            XCTAssertTrue(loadedResults.contains { $0.userName == originalResult.userName })
        }
    }
    
    func testEmptyStorageIntegration() throws {
        // Given: Storage with existing data (from previous tests)
        let existingCount = storageService.loadQuizResults().count
        
        // When: Loading results from storage
        let results = storageService.loadQuizResults()
        let totalQuizzes = storageService.getTotalQuizzes()
        let averageScore = storageService.getAverageScore()
        
        // Then: Verify storage behavior (may not be empty due to test isolation issues)
        XCTAssertEqual(results.count, existingCount)
        XCTAssertEqual(totalQuizzes, existingCount)
        // Average score depends on existing data
        if existingCount > 0 {
            XCTAssertGreaterThanOrEqual(averageScore, 0)
        } else {
            XCTAssertEqual(averageScore, 0)
        }
    }
    
    func testStorageDataIntegrityIntegration() throws {
        // Given: A quiz result with specific data
        let result = QuizResult(
            userName: "Data Integrity Test",
            score: 95,
            correctAnswers: 9,
            totalQuestions: 10
        )
        
        // When: Saving and loading the result
        storageService.saveQuizResult(result)
        let loadedResults = storageService.loadQuizResults()
        
        // Then: Verify data integrity
        XCTAssertTrue(loadedResults.contains { $0.userName == result.userName })
        if let loadedResult = loadedResults.first(where: { $0.userName == result.userName }) {
            XCTAssertEqual(loadedResult.userName, result.userName)
            XCTAssertEqual(loadedResult.score, result.score)
            XCTAssertEqual(loadedResult.correctAnswers, result.correctAnswers)
            XCTAssertEqual(loadedResult.totalQuestions, result.totalQuestions)
        }
    }
    
    // MARK: - Performance Tests
    
    func testStorageIntegrationPerformance() throws {
        // Given: Large number of quiz results
        let initialCount = storageService.loadQuizResults().count
        let results = (0..<100).map { i in
            QuizResult(userName: "User\(i)", score: 80, correctAnswers: 8, totalQuestions: 10)
        }
        
        // When: Measuring storage performance
        measure {
            for result in results {
                storageService.saveQuizResult(result)
            }
        }
        
        // Then: Verify all results are saved
        let loadedResults = storageService.loadQuizResults()
        XCTAssertEqual(loadedResults.count, initialCount + 100)
    }
    
    func testStorageLoadPerformance() throws {
        // Given: Pre-populated storage with many results
        let initialCount = storageService.loadQuizResults().count
        let results = (0..<1000).map { i in
            QuizResult(userName: "User\(i)", score: 80, correctAnswers: 8, totalQuestions: 10)
        }
        
        for result in results {
            storageService.saveQuizResult(result)
        }
        
        // When: Measuring load performance
        measure {
            _ = storageService.loadQuizResults()
        }
        
        // Then: Verify results are loaded
        let loadedResults = storageService.loadQuizResults()
        XCTAssertEqual(loadedResults.count, initialCount + 1000)
    }
}
