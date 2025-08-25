//
//  WelcomeView.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject private var viewModel: WelcomeViewModel
    @FocusState private var isNameFieldFocused: Bool
    
    let onStartQuiz: (String) -> Void
    
    init(viewModel: WelcomeViewModel, onStartQuiz: @escaping (String) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onStartQuiz = onStartQuiz
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xxl) {
            // Header
            VStack(spacing: DesignSystem.Spacing.lg) {
                Image(systemName: DesignSystem.Icons.brainProfile)
                    .font(.system(size: 100))
                    .foregroundColor(DesignSystem.Colors.primary)
                Text(DesignSystem.Text.Welcome.title)
                    .heading1()
                    .multilineTextAlignment(.center)
                
                Text(DesignSystem.Text.Welcome.subtitle)
                    .textStyle(
                        DesignSystem.Typography.title,
                        color: DesignSystem.Colors
                            .textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Name Input Form
            VStack(spacing: DesignSystem.Spacing.lg) {
                Text(DesignSystem.Text.Welcome.namePrompt)
                    .heading3()
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    TextField(DesignSystem.Text.Welcome.namePlaceholder, text: $viewModel.userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textStyle(DesignSystem.Typography.h4)
                        .standardPadding()
                        .background(DesignSystem.Colors.surface)
                        .standardCornerRadius()
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .stroke(viewModel.isNameValid ? DesignSystem.Colors.success : DesignSystem.Colors.border, lineWidth: 2)
                        )
                        .focused($isNameFieldFocused)
                        .onChange(of: viewModel.userName) { oldValue, newValue in
                            viewModel.validateName(newValue)
                            
                        }
                        .onSubmit {
                            if viewModel.canStartQuiz {
                                startQuiz()
                            }
                        }
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                
                    if !viewModel.userName.isEmpty && !viewModel.isNameValid {
                        Text(DesignSystem.Text.Welcome.nameValidationError)
                            .caption()
                            .foregroundColor(DesignSystem.Colors.error)
                            .padding(.leading, DesignSystem.Spacing.xs)
                    }
                    
                }
                
                Button(action: startQuiz) {
                    HStack {
                        Image(systemName: DesignSystem.Icons.play)
                        Text(DesignSystem.Text.Welcome.startButton)
                    }
                    .textStyle(DesignSystem.Typography.button, color: .white)
                    .frame(maxWidth: .infinity)
                    .standardPadding()
                    .background(
                        viewModel.canStartQuiz ? DesignSystem.Colors.primary
                        : DesignSystem.Colors.secondary)
                    .standardCornerRadius()
                }
                .disabled(!viewModel.canStartQuiz)
                .animation(
                    DesignSystem.Animation.fast,
                    value: viewModel.canStartQuiz
                )
            }
            .horizontalPadding()
            
            Spacer()
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(DesignSystem.Text.Welcome.footerTitle)
                    .bodyMedium()
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                Text(DesignSystem.Text.Welcome.footerSubtitle)
                    .caption()
                    .multilineTextAlignment(.center)
            }
        }
        .standardPadding()
        .standardBackground()
        .onAppear() {
            isNameFieldFocused = true
        }
    }
    
    private func startQuiz() {
        let trimmedName = viewModel.getTrimmedName()
        guard !trimmedName.isEmpty else {
            return
        }
        onStartQuiz(trimmedName)
    }
}

#Preview {
    WelcomeView(
        viewModel: ServiceContainer.shared.makeWelcomeViewModel(), onStartQuiz: {name in
            print("Starting quiz for: \(name)")
        }
    )
}
