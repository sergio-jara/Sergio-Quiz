//
//  QuizStorageServiceProtocol.swift
//  DynaQuiz
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

protocol QuizStorageServiceProtocol {
    func saveQuizResult(_ result: QuizResult)
    func loadQuizResults() -> [QuizResult]
    func getTotalQuizzes() -> Int
    func getAverageScore() -> Int
}
