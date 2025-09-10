//
//  RealmQuizResult.swift
//  DynaQuiz
//
//  Created by sergio jara on 25/08/25.
//

import Foundation
import RealmSwift

class RealmQuizResult: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userName: String
    @Persisted var score: Int
    @Persisted var correctAnswers: Int
    @Persisted var totalQuestions: Int
    @Persisted var date: Date
    
    convenience init(from quizResult: QuizResult) {
        self.init()
        self.id = quizResult.id.uuidString
        self.userName = quizResult.userName
        self.score = quizResult.score
        self.correctAnswers = quizResult.correctAnswers
        self.totalQuestions = quizResult.totalQuestions
        self.date = quizResult.date
        
    }
    
    func toQuizResult() -> QuizResult {
        return QuizResult(
            id: UUID(uuidString: id) ?? UUID(),
            userName: userName,
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            date: date)
    }
}
