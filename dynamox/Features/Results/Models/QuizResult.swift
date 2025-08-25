//
//  QuizResult.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

struct QuizResult: Identifiable, Codable {
    var id: UUID
    let userName: String
    let score: Int
    let correctAnswers: Int
    let totalQuestions: Int
    let date: Date
    let questions: [QuizQuestion]
    
    init(id: UUID = UUID(), userName: String, score: Int, correctAnswers: Int, totalQuestions: Int, date: Date = Date(), questions: [QuizQuestion]) {
        self.id = id
        self.userName = userName
        self.score = score
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
        self.date = date
        self.questions = questions
    }
}
