//
//  BaseViewModel.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import Foundation
import SwiftUI

// MARK - BAase View Model
@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    
    // MARK: - Error Handling
    func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            errorMessage = apiError.errorDescription
        } else {
            errorMessage = error.localizedDescription
        }
        
        showError = true
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
    
    // MARK: - Loading State
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
}
