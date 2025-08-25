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
                    ScoreView(viewModel: viewModel, onBackToWelcome: {
                        showingQuiz = false
                    })
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
        VStack(spacing: 0) {
            // Fixed Progress Header at top
            progressHeader
            
            // Scrollable content area
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.md) {
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
                .padding(.bottom, 120) // Add bottom padding to account for fixed button area
            }
        }
        .overlay(
            // Fixed bottom button area
            VStack {
                Spacer()
                bottomButtonArea
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.bottom, DesignSystem.Spacing.md)
        )
        .quizBackground()
    }
    
    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
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
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
        .horizontalPadding()
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(DesignSystem.Colors.surface)
        .standardCornerRadius()
        .horizontalPadding()
    }
    
    // MARK: - Question Content
    private func questionContent(_ question: QuizQuestion) -> some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Question statement
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(question.statement)
                    .textStyle(DesignSystem.Typography.h4, color: DesignSystem.Colors.text)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Answer options
            VStack(spacing: DesignSystem.Spacing.xs) {
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
            
            // Question content only - no button area here anymore
        }
    }
    
    // MARK: - Bottom Button Area
    private var bottomButtonArea: some View {
        Group {
            if !viewModel.isAnswerSubmitted {
                // Submit button
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
            } else {
                // Result and next question
                VStack(spacing: DesignSystem.Spacing.md) {
                    // Clean result indicator with subtle animation
                    HStack {
                        Spacer()
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Image(systemName: viewModel.isAnswerCorrect ? DesignSystem.Icons.checkmark : DesignSystem.Icons.xmark)
                                .font(.title2)
                                .foregroundColor(viewModel.isAnswerCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                                .scaleEffect(1.2)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.isAnswerCorrect)
                            
                            Text(viewModel.isAnswerCorrect ? DesignSystem.Text.Quiz.correctAnswer : DesignSystem.Text.Quiz.incorrectAnswer)
                                .textStyle(DesignSystem.Typography.bodyMedium, color: viewModel.isAnswerCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                        .stroke(viewModel.isAnswerCorrect ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 2)
                                )
                        )
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.isAnswerCorrect)
                        Spacer()
                    }
                    .padding(.top, DesignSystem.Spacing.xs)
                    
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
