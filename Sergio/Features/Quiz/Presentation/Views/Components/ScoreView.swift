//
//  ScoreView.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//

import SwiftUI

struct ScoreView: View {
    
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Header
            VStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: DesignSystem.Icons.trophy)
                    .font(.system(size: 60))
                    .foregroundColor(DesignSystem.Colors.trophy)
                
                Text(AppStrings.Results.quizComplete)
                    .heading2()
                
                if !viewModel.userName.isEmpty {
                    Text(
                        String(
                            format: AppStrings.Results.congratulationsFormat,
                            viewModel.userName))
                    .textStyle(
                        DesignSystem.Typography.bodyMedium,
                        color: DesignSystem.Colors
                            .primary)
                }
            }
            
            // Score Display
            VStack(spacing: DesignSystem.Spacing.md) {
                Text(viewModel.scoreMessage)
                    .textStyle(
                        DesignSystem.Typography.bodyMedium,
                        color: DesignSystem.Colors
                            .textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: DesignSystem.Spacing.md) {
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text(viewModel.scoreText)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(DesignSystem.Colors.primary)
                        Text(AppStrings.Results.score)
                            .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.textSecondary)
                    }
                    
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text("\(Int(viewModel.percentageScore))%")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(DesignSystem.Colors.success)
                        Text(AppStrings.Results.percentage)
                            .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.textSecondary)
                    }
                }
            }
            
            // Performance Bar
            VStack(spacing: DesignSystem.Spacing.xs) {
                Text(AppStrings.Results.performance)
                    .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.textSecondary)
                
                ProgressView(value: viewModel.percentageScore, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .frame(height: 16)
                
                HStack {
                    Text("0%")
                        .caption()
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("100%")
                        .caption()
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
            .horizontalPadding()
            
            // Action Buttons
            VStack(spacing: DesignSystem.Spacing.sm) {
                Button(action: {
                    viewModel.restartQuiz()
                }) {
                    HStack {
                        Image(systemName: DesignSystem.Icons.restart)
                        Text(AppStrings.Results.restartQuiz)
                    }
                    .textStyle(DesignSystem.Typography.button, color: .white)
                    .frame(maxWidth: .infinity)
                    .standardPadding()
                    .background(DesignSystem.Colors.primary)
                    .standardCornerRadius()
                }
            }
        }
        .standardPadding()
        .standardBackground()
        .navigationTitle(AppStrings.Results.tabTitle)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        
    }
    
    private var progressColor: Color {
        switch viewModel.percentageScore {
        case 90...100:
            return DesignSystem.Colors.success
        case 70..<90:
            return DesignSystem.Colors.primary
        case 50..<70:
            return DesignSystem.Colors.warning
        case 30..<50:
            return DesignSystem.Colors.trophy
        default:
            return DesignSystem.Colors.error
        }
    }
}
