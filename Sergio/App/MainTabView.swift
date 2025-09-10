//
//  MainTabView.swift
//  Sergio
//
//  Created by sergio jara on 24/08/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var userName = ""
    @State private var showingWelcome = true
    
    var body: some View {
        TabView {
            QuizTabView(
                viewModel: ServiceContainer.shared.makeQuizViewModel(),
                coordinator: ServiceContainer.shared.makeQuizCoordinator(),
                userName: userName,
                showingWelcome: $showingWelcome
            )
                .tabItem{
                    Image(systemName: DesignSystem.Icons.brainProfile)
                    Text(AppStrings.Quiz.tabTitle)
                }
            
            // Results Tab
            ResultsTabView(
                viewModel: ServiceContainer.shared.makeResultsViewModel()
            )
            .tabItem {
                Image(systemName: DesignSystem.Icons.results)
                Text(AppStrings.Results.tabTitle)
            }
        }
        .tabBarBackground()
        .sheet(isPresented: $showingWelcome) {
            WelcomeView(
                viewModel: ServiceContainer.shared.makeWelcomeViewModel(),
                onStartQuiz: { name in
                    userName = name
                    showingWelcome = false
                }
            )
        }
    }
}


#Preview {
    MainTabView()
}
