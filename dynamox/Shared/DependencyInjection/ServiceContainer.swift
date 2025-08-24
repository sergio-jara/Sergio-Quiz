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
    
    @MainActor func makeWelcomeViewModel() -> WelcomeViewModel {
        WelcomeViewModel()
    }
    
}
