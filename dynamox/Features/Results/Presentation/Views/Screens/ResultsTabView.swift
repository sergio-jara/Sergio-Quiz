//
//  ResultsTabView.swift
//  dynamox
//
//  Created by sergio jara on 25/08/25.
//

import SwiftUI

struct ResultsTabView: View {
    @StateObject private var viewModel: ResultsViewModel
    
    init(viewModel: ResultsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                if viewModel.hasResult {
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            // Overall Stats
                            VStack(spacing: DesignSystem.Spacing.md) {
                                Text(AppStrings.Results.performanceTitle)
                                    .heading2()
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: DesignSystem.Spacing.xl) {
                                    StatCard(
                                        title: AppStrings.Results.totalQuizzes,
                                        value: "\(viewModel.totalQuizzes)",
                                        icon: DesignSystem.Icons.totalQuizzes
                                    )
                                    StatCard(
                                        title: AppStrings.Results.averageScore,
                                        value: "\(viewModel.averageScore)%",
                                        icon: DesignSystem.Icons.averageScore
                                    )
                                }
                            }
                            .standardPadding()
                            .background(DesignSystem.Colors.surface)
                            .standardCornerRadius()
                            
                            // Recent Results
                            VStack(
                                alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                    Text(
                                        AppStrings.Results.recentResults
                                    ).heading3()
                                    
                                    ForEach(viewModel.recentResults) { result in
                                        ResultRowView(result: result)
                                        
                                    }
                                    
                                }
                                .standardPadding()
                                .background(DesignSystem.Colors.surface)
                                .standardCornerRadius()
                        }
                        .standardPadding()
                    }
                } else {
                    // No results state
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Image(systemName: DesignSystem.Icons.noResults)
                            .font(.system(size: 80))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        Text(AppStrings.Results.noResultsYet)
                            .heading2()
                            .multilineTextAlignment(.center)
                        
                        Text(AppStrings.Results.completeQuizForResults)
                            .textStyle(DesignSystem.Typography.bodyMedium, color: DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .standardPadding()
                }
                
            }
            .navigationTitle(AppStrings.Results.tabTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.refreshResults()
            }
        }
    }
}


struct ResultRowView: View {
    let result: QuizResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(result.userName)
                    .textStyle(DesignSystem.Typography.h4)
                
                Text(result.date.formatted(date: .abbreviated, time: .shortened))
                    .caption()
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                Text("\(result.score)%")
                    .textStyle(DesignSystem.Typography.h4)
                    .foregroundColor(result.score >= 70 ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                
                Text("\(result.correctAnswers)/\(result.totalQuestions)")
                    .caption()
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .standardPadding()
        .background(DesignSystem.Colors.background)
        .standardCornerRadius()
    }
}
