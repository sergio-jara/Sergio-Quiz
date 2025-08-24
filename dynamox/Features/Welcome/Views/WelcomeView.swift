//
//  WelcomeView.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var userName = ""
    @State private var isNameValid = false
    @FocusState private var isNameFieldFocused: Bool
    
    let onStartQuiz: (String) -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            
        }
    }
}

//#Preview {
//    WelcomeView()
//}
