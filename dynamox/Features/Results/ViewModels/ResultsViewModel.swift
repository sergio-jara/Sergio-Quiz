//
//  ResultsViewModel.swift
//  dynamox
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
    
    private let quizStorageService: QuizStorageServiceProtocol
    
    var hasResult: Bool {
        !recentResults.isEmpty
    }
    
    init(quizStorageService: QuizStorageServiceProtocol) {
        self.quizStorageService = quizStorageService
        super.init()
        loadResults()
    }
    
    func loadResults() {
        recentResults = quizStorageService.loadQuizResults()
        updateStatistics()
    }
    
    func saveResult(_ result: QuizResult) {
        // Save to storage service first
        quizStorageService.saveQuizResult(result)
        
        // Then update local array
        recentResults.insert(result, at: 0)
        updateStatistics()
    }
    
    func refreshResults() {
        loadResults()
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