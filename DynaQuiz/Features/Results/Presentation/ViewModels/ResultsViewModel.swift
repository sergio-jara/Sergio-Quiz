//
//  ResultsViewModel.swift
//  DynaQuiz
//
//  Created by sergio jara on 25/08/25.
//

import Foundation
import SwiftUI

@MainActor
class ResultsViewModel: BaseViewModel {
    @Published var recentResults: [QuizResult] = []
    @Published var totalQuizzes: Int = 0
    @Published var averageScore: Int = 0
    
    private let quizRepository: QuizRepositoryProtocol
    
    var hasResult: Bool {
        !recentResults.isEmpty
    }
    
    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
        super.init()
        Task {
            await loadResults()
        }
    }
    
    func loadResults() async {
        do {
            let results = try await quizRepository.loadQuizResults()
            let total = try await quizRepository.getTotalQuizzes()
            let average = try await quizRepository.getAverageScore()
            
            // Update UI properties (already on main thread due to @MainActor)
            recentResults = results
            totalQuizzes = total
            averageScore = average
        } catch {
            handleError(error)
        }
    }
    
    func saveResult(_ result: QuizResult) async {
        do {
            try await quizRepository.saveQuizResult(result)
            
            // Update UI properties (already on main thread due to @MainActor)
            recentResults.insert(result, at: 0)
            updateStatistics()
        } catch {
            handleError(error)
        }
    }
    
    func refreshResults() {
        Task {
            await loadResults()
        }
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
}
