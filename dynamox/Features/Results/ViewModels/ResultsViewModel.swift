//
//  ResultsViewModel.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

@MainActor
class ResultsViewModel: BaseViewModel {
    @Published var recentResults: [QuizResult] = []
    @Published var totalQuizzes: Int = 0
    @Published var averageScore: Int = 0
    
    var hasResult: Bool {
        !recentResults.isEmpty
    }
    
    override init() {
        super.init()
        loadResults()
    }
    
    func loadResults() {
        // TODO: load from persistant storage
        loadMockResults()
    }
    
    func saveResult(_ result: QuizResult) {
        recentResults.insert(result, at: 0)
        updateStatistics()
        
        // TODO: SAve to persistant storage
    }
    
    private func updateStatistics() {
        totalQuizzes = recentResults.count
        
        if !recentResults.isEmpty {
            let totalScore = recentResults.reduce(0) { $0 + $1.score }
            averageScore = totalScore / recentResults.count
        } else {
            averageScore = 0
        }
    }
    
    private func loadMockResults() {
        // Mock data for development
        let mockResults = [
            QuizResult(
                id: UUID(),
                userName: "sergio",
                score: 85,
                correctAnswers: 8,
                totalQuestions: 10,
                date: Date().addingTimeInterval(-3600),
                questions: []
            ),
            QuizResult(
                id: UUID(),
                userName: "jara",
                score: 92,
                correctAnswers: 9,
                totalQuestions: 10,
                date: Date().addingTimeInterval(-7200),
                questions: []
            )
        ]
        
        recentResults = mockResults
        updateStatistics()
    }
}
