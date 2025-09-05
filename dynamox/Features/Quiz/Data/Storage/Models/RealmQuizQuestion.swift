//
//  RealmQuizQuestion.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//


import Foundation
import RealmSwift

class RealmQuizQuestion: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var statement: String
    @Persisted var options: List<String>
    
    convenience init(from quizQuestion: QuizQuestion) {
        self.init()
        self.id = quizQuestion.id
        self.statement = quizQuestion.statement
        self.options = List<String>()
        self.options.append(objectsIn: quizQuestion.options)
    }
    
    func toQuizQuestion() -> QuizQuestion {
        return QuizQuestion(
            id: id,
            statement: statement,
            options: Array(options)
        )
    }
}
