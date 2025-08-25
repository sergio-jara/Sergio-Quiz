//
//  QuizQuestion.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import Foundation

// MARK: - Quiz Question Response
struct QuizQuestion: Codable {
    let id: String
    let statement: String
    let options: [String]
}


