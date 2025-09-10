//
//  QuizError.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Quiz Domain Errors
enum QuizError: Error, LocalizedError {
    case invalidUserName
    case invalidQuestionId
    case invalidAnswer
    case invalidQuizData
    case quizNotStarted
    case quizAlreadyCompleted
    case networkUnavailable
    case questionNotFound
    case storageError
    
    var errorDescription: String? {
        switch self {
        case .invalidUserName:
            return "User name cannot be empty"
        case .invalidQuestionId:
            return "Invalid question ID"
        case .invalidAnswer:
            return "Answer cannot be empty"
        case .invalidQuizData:
            return "Invalid quiz data provided"
        case .quizNotStarted:
            return "Quiz has not been started"
        case .quizAlreadyCompleted:
            return "Quiz has already been completed"
        case .networkUnavailable:
            return "Network connection is unavailable"
        case .questionNotFound:
            return "Question not found"
        case .storageError:
            return "Failed to save quiz data"
        }
    }
}
