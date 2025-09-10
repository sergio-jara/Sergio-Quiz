//
//  AnswerOptionButton.swift
//  Sergio
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

struct AnswerOptionButton: View {
    
    let option: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                    .bodyText()
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let isCorrect = isCorrect {
                    Image(
                        systemName: isCorrect ? DesignSystem.Icons.checkmark : DesignSystem
                            .Icons.xmark)
                    .foregroundColor(
                        isCorrect ? DesignSystem.Colors.success : DesignSystem
                            .Colors.error)
                } else if isSelected {
                    Image(systemName: DesignSystem.Icons.checkmark)
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            .standardPadding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .standardCornerRadius()
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? DesignSystem.Colors.success.opacity(0.1) : DesignSystem.Colors.error.opacity(0.1)
        } else if isSelected {
            return DesignSystem.Colors.primary.opacity(0.1)
        } else {
            return DesignSystem.Colors.surface
        }
    }
    
    private var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error
        } else if isSelected {
            return DesignSystem.Colors.primary
        } else {
            return DesignSystem.Colors.border
        }
    }
}
