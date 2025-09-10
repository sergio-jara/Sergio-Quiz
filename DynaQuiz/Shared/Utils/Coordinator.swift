//
//  Coordinator.swift
//  DynaQuiz
//
//  Created by sergio jara on 24/08/25.
//

import Foundation
import SwiftUI

// MARK: - Coordinator Protocol
protocol Coordinator: ObservableObject {
    var navigationPath: NavigationPath { get set }
    
    func start()
    func navigate(to destination: any Hashable)
    func pop()
    func popToRoot()
}

// MARK: - Base Coordinator Implementation
class BaseCoordinator: Coordinator {
    @Published var navigationPath = NavigationPath()
    
    func start() {
        // ovveride in subclasses
    }
    
    func navigate(to destination: any Hashable) {
        navigationPath.append(destination)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
