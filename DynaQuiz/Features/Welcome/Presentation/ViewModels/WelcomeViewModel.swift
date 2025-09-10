//
//  WelcomeViewModel.swift
//  DynaQuiz
//
//  Created by sergio jara on 24/08/25.
//

import Foundation
import SwiftUI

@MainActor
class WelcomeViewModel: BaseViewModel {
    @Published var userName = ""
    @Published var isNameValid = false
    
    var canStartQuiz: Bool {
        isNameValid
    }
    
    func validateName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        isNameValid = trimmed.count >= 2 && trimmed.count <= 50
    }
    
    func getTrimmedName() -> String {
        userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
