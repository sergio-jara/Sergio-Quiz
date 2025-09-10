//
//  StatCard.swift
//  Sergio
//
//  Created by sergio jara on 25/08/25.
//
import Foundation
import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text(value)
                .heading2()
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text(title)
                .caption()
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .standardPadding()
        .background(DesignSystem.Colors.background)
        .standardCornerRadius()
    }
}
