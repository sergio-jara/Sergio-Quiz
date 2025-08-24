//
//  ServiceContainer.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import Foundation

// MARK: - Service Container
class ServiceContainer {
    static let shared = ServiceContainer()
    
    private init() {}
    
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService(baseURL: "https://quiz-api-bwi5hjqyaq-uc.a.run.app")
    }()
    
    lazy var quizAPIClient: QuizAPIClientProtocol = {
        QuizAPIClient(networkService: networkService)
    }()

    // MARK: - View Models
    @MainActor func makeQuizViewModel() -> QuizViewModel {
        QuizViewModel(apiClient: quizAPIClient)
    }
    
    @MainActor func makeWelcomeViewModel() -> WelcomeViewModel {
        WelcomeViewModel()
    }
    
    // MARK: - Coordinators
    func makeQuizCoordinator() -> QuizCoordinator {
        QuizCoordinator()
    }
    
}
