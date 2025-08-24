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
    
    // MARK: - Async Task Wrapper
    func performAsyncTask<T>(
        _ task: @escaping () async throws -> T,
        completion: @escaping (T) -> Void) {
            Task {
                do {
                    setLoading(true)
                    clearError()
                    let result = try await task()
                    await MainActor.run {
                        completion(result)
                        setLoading(false)
                    }
                } catch {
                    await MainActor.run {
                        handleError(error)
                        setLoading(false)
                    }
                }
            }
        }
    
}
