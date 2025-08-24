//
//  QuizTabView.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

struct QuizTabView: View {
    @StateObject private var viewModel: QuizViewModel
    let userName: String
    @Binding var showingWelcome: Bool
    
    init(viewModel: QuizViewModel, userName: String, showingWelcome: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.userName = userName
        self._showingWelcome = showingWelcome
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.xl) {
                if viewModel.currentQuestion != nil {
                    
                }
            }
        }
    }
}

//#Preview {
//    QuizTabView()
//}
