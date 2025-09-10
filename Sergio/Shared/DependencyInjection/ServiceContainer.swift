//
//  ServiceContainer.swift
//  Sergio
//
//  Created by sergio jara on 24/08/25.
//

import Foundation

// MARK: - Service Container
class ServiceContainer {
    static let shared = ServiceContainer()
    
    private init() {}
    
    // MARK: - Core Services
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService(baseURL: "https://quiz-api-bwi5hjqyaq-uc.a.run.app")
    }()
    
    lazy var quizAPIClient: QuizAPIClientProtocol = {
        QuizAPIClient(networkService: networkService)
    }()
    
    lazy var realmService: RealmServiceProtocol = {
        RealmService()
    }()
    
    lazy var quizStorageService: QuizStorageServiceProtocol = {
        QuizStorageService(realmService: realmService)
    }()
    
    // MARK: - Repository
    lazy var quizRepository: QuizRepositoryProtocol = {
        QuizRepository(apiClient: quizAPIClient, storageService: quizStorageService)
    }()
    
    // MARK: - Domain Services
    lazy var scoreCalculationService: ScoreCalculationServiceProtocol = {
        ScoreCalculationService()
    }()
    
    // MARK: - Use Cases
    lazy var startQuizUseCase: StartQuizUseCaseProtocol = {
        StartQuizUseCase(quizRepository: quizRepository)
    }()
    
    lazy var loadNextQuestionUseCase: LoadNextQuestionUseCaseProtocol = {
        LoadNextQuestionUseCase(quizRepository: quizRepository)
    }()
    
    lazy var submitAnswerUseCase: SubmitAnswerUseCaseProtocol = {
        SubmitAnswerUseCase(quizRepository: quizRepository)
    }()
    
    lazy var completeQuizUseCase: CompleteQuizUseCaseProtocol = {
        CompleteQuizUseCase(quizRepository: quizRepository, scoreCalculationService: scoreCalculationService)
    }()

    // MARK: - View Models
    @MainActor func makeQuizViewModel() -> QuizViewModel {
        QuizViewModel(
            startQuizUseCase: startQuizUseCase,
            loadNextQuestionUseCase: loadNextQuestionUseCase,
            submitAnswerUseCase: submitAnswerUseCase,
            completeQuizUseCase: completeQuizUseCase,
            scoreCalculationService: scoreCalculationService
        )
    }
    
    @MainActor func makeWelcomeViewModel() -> WelcomeViewModel {
        WelcomeViewModel()
    }
    
    @MainActor func makeResultsViewModel() -> ResultsViewModel {
        ResultsViewModel(quizRepository: quizRepository)
    }
    
    // MARK: - Coordinators
    func makeQuizCoordinator() -> QuizCoordinator {
        QuizCoordinator()
    }
    
}
