import Foundation

// MARK: - Quiz View Model
@MainActor
class QuizViewModel: BaseViewModel {
    @Published var currentQuestion: QuizQuestion?
    @Published var selectedAnswer: String = ""
    @Published var isAnswerSubmitted = false
    @Published var isAnswerCorrect = false
    @Published var currentQuestionNumber = 0
    @Published var correctAnswers = 0
    @Published var isQuizCompleted = false
    @Published var userName: String = ""
    
    private let apiClient: QuizAPIClientProtocol
    let totalQuestions = 10
    
    init(apiClient: QuizAPIClientProtocol) {
        self.apiClient = apiClient
        super.init()
    }
    
    // MARK: - Public Methods
    func startQuiz(with name: String) {
        userName = name
        setLoading(true)
        clearError()
        Task {
            await loadRandomQuestion()
        }
    }
    
    func loadRandomQuestion() async {
        guard currentQuestionNumber < totalQuestions else {
            isQuizCompleted = true
            return
        }
        
        do {
            clearError()
            let question = try await apiClient.fetchRandomQuestion()
            currentQuestion = question
            resetQuizState()
            setLoading(false)
        } catch {
            handleError(error)
            setLoading(false)
        }
    }
    
    func submitAnswer() async {
        guard let question = currentQuestion, !selectedAnswer.isEmpty else { return }
        
        do {
            setLoading(true)
            clearError()
            let response = try await apiClient.submitAnswer(
                questionId: question.id,
                answer: selectedAnswer
            )
            
            isAnswerCorrect = response.result
            isAnswerSubmitted = true
            
            if response.result {
                correctAnswers += 1
            }
            
            setLoading(false)
        } catch {
            handleError(error)
            setLoading(false)
        }
    }
    
    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
    }
    
    func nextQuestion() {
        currentQuestionNumber += 1
        
        if currentQuestionNumber >= totalQuestions {
            isQuizCompleted = true
        } else {
            Task {
                await loadRandomQuestion()
            }
        }
    }
    
    func restartQuiz() {
        currentQuestionNumber = 0
        correctAnswers = 0
        isQuizCompleted = false
        currentQuestion = nil
        resetQuizState()
        Task {
            await loadRandomQuestion()
        }
    }
    
    // MARK: - Computed Properties
    var scoreText: String {
        "\(correctAnswers)/\(totalQuestions)"
    }
    
    var percentageScore: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    var scoreMessage: String {
        switch percentageScore {
        case 90...100:
            return DesignSystem.Text.Results.excellentScore
        case 70...89:
            return DesignSystem.Text.Results.greatScore
        case 50...69:
            return DesignSystem.Text.Results.goodScore
        case 30...49:
            return DesignSystem.Text.Results.fairScore
        default:
            return DesignSystem.Text.Results.poorScore
        }
    }
    
    // MARK: - Private Methods
    private func resetQuizState() {
        selectedAnswer = ""
        isAnswerSubmitted = false
        isAnswerCorrect = false
    }
}
