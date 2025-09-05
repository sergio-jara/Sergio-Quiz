import SwiftUI
import Combine

struct QuizTabView: View {
    @StateObject private var viewModel: QuizViewModel
    @StateObject private var coordinator: QuizCoordinator
    let userName: String
    @Binding var showingWelcome: Bool
    
    init(viewModel: QuizViewModel, coordinator: QuizCoordinator, userName: String, showingWelcome: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.userName = userName
        self._showingWelcome = showingWelcome
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                mainContent
            }
            .navigationTitle(AppStrings.Quiz.tabTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !userName.isEmpty && viewModel.currentQuestion == nil && !viewModel.isLoading {
                    viewModel.startQuiz(with: userName)
                }
            }
            .onReceive(Just(userName)) { newUserName in
                if !newUserName.isEmpty && viewModel.currentQuestion == nil && !viewModel.isLoading {
                    viewModel.startQuiz(with: newUserName)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.currentQuestion != nil {
            QuizView(viewModel: viewModel, coordinator: coordinator, userName: userName, showingQuiz: $showingWelcome)
        } else if !userName.isEmpty {
            quizStateContent
        } else {
            readyToStartView
        }
    }
    
    @ViewBuilder
    private var quizStateContent: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.showError {
            errorView
        } else {
            readyToStartView
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
            
                            Text(AppStrings.Quiz.loadingQuestion)
                .textStyle(DesignSystem.Typography.bodyMedium, color: DesignSystem.Colors.textSecondary)
        }
        .standardPadding()
    }
    
    private var errorView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            brainIcon
                .foregroundColor(DesignSystem.Colors.error)
            
            Text("No questions available")
                .heading2()
                .multilineTextAlignment(.center)
            
            Text("There was a problem retrieving the questions. Please try again.")
                .textStyle(DesignSystem.Typography.bodyMedium, color: DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                viewModel.startQuiz(with: userName)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .standardPadding()
    }
    
    private var readyToStartView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            brainIcon
                .foregroundColor(DesignSystem.Colors.primary)
            
                            Text(AppStrings.Quiz.readyToStart)
                .heading2()
                .multilineTextAlignment(.center)
            
                            Text(AppStrings.Quiz.tapWelcomeToBegin)
                .textStyle(DesignSystem.Typography.bodyMedium, color: DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
                            Button(AppStrings.Welcome.startButton) {
                showingWelcome = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .standardPadding()
    }
    
    private var brainIcon: some View {
        Image(systemName: DesignSystem.Icons.brainProfile)
            .font(.system(size: 80))
    }
}

#Preview {
    QuizTabView(
        viewModel: ServiceContainer.shared.makeQuizViewModel(),
        coordinator: ServiceContainer.shared.makeQuizCoordinator(),
        userName: "Test User",
        showingWelcome: .constant(false)
    )
}
