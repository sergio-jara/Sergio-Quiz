import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    @ObservedObject var coordinator: QuizCoordinator
    let userName: String
    @Binding var showingQuiz: Bool
    
    init(viewModel: QuizViewModel, coordinator: QuizCoordinator, userName: String, showingQuiz: Binding<Bool>) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.userName = userName
        self._showingQuiz = showingQuiz
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isQuizCompleted {
                    Text("completed")
                } else {
                    quizContent
                }
            }
           
            .alert(DesignSystem.Text.Quiz.error, isPresented: $viewModel.showError) {
                Button(DesignSystem.Text.Quiz.ok) {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? DesignSystem.Text.Quiz.unknownError)
            }
        }
    }
    
    // MARK: - Quiz Content
    private var quizContent: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Progress Header
            progressHeader
            
            if viewModel.isLoading {
                ProgressView(DesignSystem.Text.Quiz.loadingQuestion)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let question = viewModel.currentQuestion {
                questionContent(question)
            } else {
                noQuestionContent
            }
        }
        .standardPadding()
        .quizBackground()
    }
    
    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // User name and progress
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    if !viewModel.userName.isEmpty {
                        Text(String(format: DesignSystem.Text.Quiz.helloFormat, viewModel.userName))
                            .heading3()
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                    
                    Text(String(format: DesignSystem.Text.Quiz.questionNumberFormat, viewModel.currentQuestionNumber + 1, viewModel.totalQuestions))
                            .textStyle(DesignSystem.Typography.bodySmall, color: DesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Image(systemName: DesignSystem.Icons.checkmark)
                        .foregroundColor(DesignSystem.Colors.success)
                    Text("\(viewModel.correctAnswers)")
                        .heading3()
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            
            ProgressView(value: Double(viewModel.currentQuestionNumber), total: Double(viewModel.totalQuestions))
                .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.Colors.primary))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .horizontalPadding()
        .verticalPadding()
        .background(DesignSystem.Colors.surface)
        .standardCornerRadius()
        .horizontalPadding()
    }
    
    // MARK: - Question Content
    private func questionContent(_ question: QuizQuestion) -> some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Question statement
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                Text(question.statement)
                    .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.text)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Answer options
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(DesignSystem.Text.Quiz.selectAnswer)
                    .heading3()
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                ForEach(question.options, id: \.self) { option in
                    AnswerOptionButton(
                        option: option,
                        isSelected: viewModel.selectedAnswer == option,
                        isCorrect: viewModel.isAnswerSubmitted ? (option == question.options.first { $0 == viewModel.selectedAnswer }) : nil,
                        action: {
                            if !viewModel.isAnswerSubmitted {
                                viewModel.selectAnswer(option)
                            }
                        }
                    )
                }
            }
            
            // Submit button or Result area (fixed height to prevent layout shifts)
            ZStack {
                // Background placeholder to maintain consistent spacing
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 140)
                
                // Submit button - fixed at bottom
                if !viewModel.isAnswerSubmitted {
                    VStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await viewModel.submitAnswer()
                            }
                        }) {
                            Text(DesignSystem.Text.Quiz.submitAnswer)
                                .textStyle(DesignSystem.Typography.button, color: .white)
                                .frame(maxWidth: .infinity)
                                .standardPadding()
                                .background(viewModel.selectedAnswer.isEmpty ? DesignSystem.Colors.secondary : DesignSystem.Colors.primary)
                                .standardCornerRadius()
                        }
                        .disabled(viewModel.selectedAnswer.isEmpty)
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    // Result and next question - fixed positioning
                    VStack(spacing: DesignSystem.Spacing.md) {
                        Spacer()
                        ResultView(isCorrect: viewModel.isAnswerCorrect)
                        
                        Button(action: {
                            viewModel.nextQuestion()
                        }) {
                            Text(viewModel.currentQuestionNumber + 1 >= viewModel.totalQuestions ? DesignSystem.Text.Quiz.finishQuiz : DesignSystem.Text.Quiz.nextQuestion)
                                .textStyle(DesignSystem.Typography.button, color: .white)
                                .frame(maxWidth: .infinity)
                                .standardPadding()
                                .background(DesignSystem.Colors.success)
                                .standardCornerRadius()
                        }
                    }
                }
            }
            .frame(height: 140) // Fixed height to prevent layout shifts
        }
    }
    
    // MARK: - No Question Content
    private var noQuestionContent: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: DesignSystem.Icons.questionMark)
                .font(.system(size: 60))
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Text(DesignSystem.Text.Quiz.noQuestionAvailable)
                .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.textSecondary)
            
            Button(DesignSystem.Text.Quiz.loadQuestion) {
                Task {
                    await viewModel.loadRandomQuestion()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}


#Preview {
    QuizView(
        viewModel: ServiceContainer.shared.makeQuizViewModel(),
        coordinator: QuizCoordinator(),
        userName: "Test User",
        showingQuiz: .constant(true)
    )
}
