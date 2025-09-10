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
    
    // MARK: - Use Cases
    private let startQuizUseCase: StartQuizUseCaseProtocol
    private let loadNextQuestionUseCase: LoadNextQuestionUseCaseProtocol
    private let submitAnswerUseCase: SubmitAnswerUseCaseProtocol
    private let completeQuizUseCase: CompleteQuizUseCaseProtocol
    private let scoreCalculationService: ScoreCalculationServiceProtocol
    
    let totalQuestions = 10
    
    init(
        startQuizUseCase: StartQuizUseCaseProtocol,
        loadNextQuestionUseCase: LoadNextQuestionUseCaseProtocol,
        submitAnswerUseCase: SubmitAnswerUseCaseProtocol,
        completeQuizUseCase: CompleteQuizUseCaseProtocol,
        scoreCalculationService: ScoreCalculationServiceProtocol
    ) {
        self.startQuizUseCase = startQuizUseCase
        self.loadNextQuestionUseCase = loadNextQuestionUseCase
        self.submitAnswerUseCase = submitAnswerUseCase
        self.completeQuizUseCase = completeQuizUseCase
        self.scoreCalculationService = scoreCalculationService
        super.init()
    }
    
    // MARK: - Public Methods
    func startQuiz(with name: String) {
        userName = name
        setLoading(true)
        clearError()
        Task {
            do {
                let question = try await startQuizUseCase.execute(userName: name)
                currentQuestion = question
                resetQuizState()
                setLoading(false)
            } catch {
                handleError(error)
                setLoading(false)
            }
        }
    }
    
    func loadRandomQuestion() async {
        guard currentQuestionNumber < totalQuestions else {
            isQuizCompleted = true
            return
        }
        
        do {
            clearError()
            let question = try await loadNextQuestionUseCase.execute()
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
            let isCorrect = try await submitAnswerUseCase.execute(
                questionId: question.id,
                answer: selectedAnswer
            )
            
            isAnswerCorrect = isCorrect
            isAnswerSubmitted = true
            
            if isCorrect {
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
            Task {
                await completeQuiz()
            }
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
        let score = Int(percentageScore)
        let performanceLevel = scoreCalculationService.evaluatePerformance(score: score)
        return performanceLevel.message
    }
    
    // MARK: - Private Methods
    private func resetQuizState() {
        selectedAnswer = ""
        isAnswerSubmitted = false
        isAnswerCorrect = false
    }
    
    private func completeQuiz() async {
        do {
            let _ = try await completeQuizUseCase.execute(
                userName: userName,
                correctAnswers: correctAnswers,
                totalQuestions: totalQuestions
            )
        } catch {
            handleError(error)
        }
    }
}
