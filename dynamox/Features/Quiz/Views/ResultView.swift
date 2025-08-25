//
//  ResultView.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

// MARK: - Result View
struct ResultView: View {
    let isCorrect: Bool
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: isCorrect ? DesignSystem.Icons.checkmark : DesignSystem.Icons.xmark)
                .font(.title2)
                .foregroundColor(isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            
            Text(isCorrect ? DesignSystem.Text.Quiz.correctAnswer : DesignSystem.Text.Quiz.incorrectAnswer)
                .textStyle(DesignSystem.Typography.bodyMedium, color: isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
        }
        .padding(.horizontal, DesignSystem.Spacing.sm)
        .padding(.vertical, DesignSystem.Spacing.xs)
    }
}
