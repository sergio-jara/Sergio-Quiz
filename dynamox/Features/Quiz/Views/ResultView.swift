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
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: isCorrect ? DesignSystem.Icons.checkmark : DesignSystem.Icons.xmark)
                .font(.title)
                .foregroundColor(isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            
            Text(isCorrect ? DesignSystem.Text.Quiz.correctAnswer : DesignSystem.Text.Quiz.incorrectAnswer)
                .textStyle(DesignSystem.Typography.h4, color: isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
        }
        .standardPadding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                .fill((isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error).opacity(0.1))
        )
    }
}
