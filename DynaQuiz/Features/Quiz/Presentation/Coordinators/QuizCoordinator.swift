//
//  QuizCoordinator.swift
//  DynaQuiz
//
//  Created by sergio jara on 24/08/25.
//

import Foundation
import SwiftUI

//MARK: - Quiz Coordinator
class QuizCoordinator: BaseCoordinator {
    
    override func start() {
        navigate(to: QuizDestination.quiz)
    }
    
    func showScore() {
        navigate(to: QuizDestination.score)
    }
    
    func restartQuiz() {
        // Navigate back to quiz and reset
        navigate(to: QuizDestination.quiz)
    }
}


// MARK: - Quiz Destinations
enum QuizDestination: Hashable {
    case quiz
    case score
}
