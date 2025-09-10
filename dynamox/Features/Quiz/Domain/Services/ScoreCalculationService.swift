//
//  ScoreCalculationService.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//

import Foundation

// MARK: - Score Calculation Service Protocol
protocol ScoreCalculationServiceProtocol {
    func calculateScore(correctAnswers: Int, totalQuestions: Int) -> Int
    func evaluatePerformance(score: Int) -> PerformanceLevel
}

// MARK: - Performance Level
enum PerformanceLevel: String, CaseIterable {
    case excellent = "excellent"
    case great = "great"
    case good = "good"
    case fair = "fair"
    case poor = "poor"
    
    var message: String {
        switch self {
        case .excellent:
            return AppStrings.Results.excellentScore
        case .great:
            return AppStrings.Results.greatScore
        case .good:
            return AppStrings.Results.goodScore
        case .fair:
            return AppStrings.Results.fairScore
        case .poor:
            return AppStrings.Results.poorScore
        }
    }
}

// MARK: - Score Calculation Service Implementation
class ScoreCalculationService: ScoreCalculationServiceProtocol {
    
    func calculateScore(correctAnswers: Int, totalQuestions: Int) -> Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions)) * 100)
    }
    
    func evaluatePerformance(score: Int) -> PerformanceLevel {
        switch score {
        case 90...100:
            return .excellent
        case 70...89:
            return .great
        case 50...69:
            return .good
        case 30...49:
            return .fair
        default:
            return .poor
        }
    }
}
