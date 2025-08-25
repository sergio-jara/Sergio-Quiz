//
//  QuizStorageService.swift
//  dynamox
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
        
        return realmResults.sorted(byKeyPath: "date", ascending: false)
            .map{ $0.toQuizResult() }
    }
    
    // MARK: Statistics
    
    func getTotalQuizzes() -> Int {
        guard let realmResults = realmService.getAll(RealmQuizResult.self) else {
            return 0
        }
        return realmResults.count
    }
    
    func getAverageScore() -> Int {
        guard let results = realmService.getAll(RealmQuizResult.self) else {
            return 0
        }
        
        guard !results.isEmpty else { return 0 }
        
        let totalScore = results.reduce(0) { $0 + $1.score }
        return totalScore / results.count
    }
}
