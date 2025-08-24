//
//  DesignSystem.swift
//  dynamox
//
//  Created by sergio jara on 24/08/25.
//

import SwiftUI

// MARK: - Design System
struct DesignSystem {
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Typography
    struct Typography {
        static let h1 = Font.system(size: 32, weight: .bold, design: .default)
        static let h2 = Font.system(size: 28, weight: .bold, design: .default)
        static let h3 = Font.system(size: 24, weight: .semibold, design: .default)
        static let h4 = Font.system(size: 20, weight: .semibold, design: .default)
        static let title = Font.system(size: 18, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let bodyMedium = Font.system(size: 16, weight: .medium, design: .default)
        static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .medium, design: .default)
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
    }
    
    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primary = Color.blue
        static let primaryLight = Color.blue.opacity(0.8)
        static let primaryDark = Color.blue.opacity(1.2)
        
        // Secondary Colors
        static let secondary = Color.gray
        static let secondaryLight = Color.gray.opacity(0.6)
        
        // Semantic Colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue
        
        // Neutral Colors
        static let background = Color(.systemBackground)
        static let surface = Color(.secondarySystemBackground)
        static let text = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        static let border = Color(.separator)
        
        // Quiz-specific Colors
        static let quizBackground = Color(.systemGroupedBackground)
        static let correctAnswer = Color.green
        static let incorrectAnswer = Color.red
        static let trophy = Color.yellow
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Animation
    struct Animation {
        static let fast: SwiftUI.Animation = .easeInOut(duration: 0.2)
        static let normal: SwiftUI.Animation = .easeInOut(duration: 0.3)
        static let slow: SwiftUI.Animation = .easeInOut(duration: 0.5)
        static let spring: SwiftUI.Animation = .spring(response: 0.5, dampingFraction: 0.8)
    }
}

// MARK: - Shadow Structure
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions
extension View {
    // MARK: - Spacing Modifiers
    func customPadding(_ spacing: CGFloat) -> some View {
        self.padding(spacing)
    }
    
    func paddingHorizontal(_ spacing: CGFloat) -> some View {
        self.padding(.horizontal, spacing)
    }
    
    func paddingVertical(_ spacing: CGFloat) -> some View {
        self.padding(.vertical, spacing)
    }
    
    // MARK: - Typography Modifiers
    func textStyle(_ font: Font, color: Color = DesignSystem.Colors.text) -> some View {
        self.font(font)
            .foregroundColor(color)
    }
    
    func heading1(_ color: Color = DesignSystem.Colors.text) -> some View {
        self.textStyle(DesignSystem.Typography.h1, color: color)
    }
    
    func heading2(_ color: Color = DesignSystem.Colors.text) -> some View {
        self.textStyle(DesignSystem.Typography.h2, color: color)
    }
    
    func heading3(_ color: Color = DesignSystem.Colors.text) -> some View {
        self.textStyle(DesignSystem.Typography.h3, color: color)
    }
    
    func bodyText(_ color: Color = DesignSystem.Colors.text) -> some View {
        self.textStyle(DesignSystem.Typography.body, color: color)
    }
    
    func bodyMedium(_ color: Color = DesignSystem.Colors.text) -> some View {
        self.textStyle(DesignSystem.Typography.bodyMedium, color: color)
    }
    
    func caption(_ color: Color = DesignSystem.Colors.textSecondary) -> some View {
        self.textStyle(DesignSystem.Typography.caption, color: color)
    }
    
    // MARK: - Background Modifiers
    func standardBackground() -> some View {
        self.background(DesignSystem.Colors.background)
    }
    
    func surfaceBackground() -> some View {
        self.background(DesignSystem.Colors.surface)
    }
    
    func quizBackground() -> some View {
        self.background(DesignSystem.Colors.quizBackground)
    }
    
    // MARK: - Corner Radius Modifiers
    func standardCornerRadius() -> some View {
        self.cornerRadius(DesignSystem.CornerRadius.md)
    }
    
    func smallCornerRadius() -> some View {
        self.cornerRadius(DesignSystem.CornerRadius.sm)
    }
    
    func largeCornerRadius() -> some View {
        self.cornerRadius(DesignSystem.CornerRadius.lg)
    }
    
    // MARK: - Shadow Modifiers
    func standardShadow() -> some View {
        self.shadow(
            color: DesignSystem.Shadows.medium.color,
            radius: DesignSystem.Shadows.medium.radius,
            x: DesignSystem.Shadows.medium.x,
            y: DesignSystem.Shadows.medium.y
        )
    }
    
    func smallShadow() -> some View {
        self.shadow(
            color: DesignSystem.Shadows.small.color,
            radius: DesignSystem.Shadows.small.radius,
            x: DesignSystem.Shadows.small.x,
            y: DesignSystem.Shadows.small.y
        )
    }
    
    // MARK: - Spacing Modifiers
    func standardPadding() -> some View {
        self.padding(DesignSystem.Spacing.md)
    }
    
    func largePadding() -> some View {
        self.padding(DesignSystem.Spacing.lg)
    }
    
    func extraLargePadding() -> some View {
        self.padding(DesignSystem.Spacing.xl)
    }
    
    func horizontalPadding() -> some View {
        self.padding(.horizontal, DesignSystem.Spacing.md)
    }
    
    func verticalPadding() -> some View {
        self.padding(.vertical, DesignSystem.Spacing.md)
    }
}
