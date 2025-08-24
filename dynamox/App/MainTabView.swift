//
//  MainTabView.swift
//  dynamox
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
            Text("Quiz")
                .tabItem{
                    Image(systemName: DesignSystem.Icons.brainProfile)
                    Text(DesignSystem.Text.Quiz.tabTitle)
                }
        }
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
