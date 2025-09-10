//
//  QuizStorageService.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

class QuizStorageService: QuizStorageServiceProtocol {
    private let realmService: RealmServiceProtocol
    
    init(realmService: RealmServiceProtocol) {
        self.realmService = realmService
    }
    
    // MARK: QUIZ Results Operations
    
    func saveQuizResult(_ result: QuizResult) {
        let realmResult = RealmQuizResult(from: result)
        realmService.add(realmResult)

    }
    
    func loadQuizResults() -> [QuizResult] {
        guard let realmResults = realmService.getAll(RealmQuizResult.self) else {
            return []
        }
        
        // Convert to array immediately to avoid threading issues
        let resultsArray = Array(realmResults)
        return resultsArray.sorted { $0.date > $1.date }
            .map { $0.toQuizResult() }
    }
    
    // MARK: Statistics
    
    func getTotalQuizzes() -> Int {
        guard let realmResults = realmService.getAll(RealmQuizResult.self) else {
            return 0
        }
        // Convert to array immediately to avoid threading issues
        let resultsArray = Array(realmResults)
        return resultsArray.count
    }
    
    func getAverageScore() -> Int {
        guard let results = realmService.getAll(RealmQuizResult.self) else {
            return 0
        }
        
        // Convert to array immediately to avoid threading issues
        let resultsArray = Array(results)
        guard !resultsArray.isEmpty else { return 0 }
        
        let totalScore = resultsArray.reduce(0) { $0 + $1.score }
        return totalScore / resultsArray.count
    }
}
