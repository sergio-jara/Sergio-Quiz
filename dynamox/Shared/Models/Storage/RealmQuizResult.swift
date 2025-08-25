//
//  RealmQuizResult.swift
//  dynamox
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
    @Persisted var questions: List<RealmQuizQuestion>
    
    convenience init(from quizResult: QuizResult) {
        self.init()
        self.id = quizResult.id.uuidString
        self.userName = quizResult.userName
        self.score = quizResult.score
        self.correctAnswers = quizResult.correctAnswers
        self.totalQuestions = quizResult.totalQuestions
        self.date = quizResult.date
        self.questions = List<RealmQuizQuestion>()
        self.questions.append(objectsIn: quizResult.questions.map { RealmQuizQuestion(from: $0) })
    }
    
    func toQuizResult() -> QuizResult {
        return QuizResult(
            id: UUID(uuidString: id) ?? UUID(),
            userName: userName,
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            date: date,
            questions: questions.map { $0.toQuizQuestion() }
        )
    }
}
