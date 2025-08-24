# Design System for Dynamox

This document explains how to use the comprehensive design system implemented in the dynamox project for consistent spacing, typography, colors, and styling.

## Overview

The design system provides a centralized way to maintain consistent visual design across all views in the app. It includes:

- **Spacing**: Consistent spacing values (xs, sm, md, lg, xl, xxl, xxxl)
- **Typography**: Predefined font styles and sizes
- **Colors**: Semantic color palette with light/dark mode support
- **Corner Radius**: Standardized corner radius values
- **Shadows**: Consistent shadow styles
- **Animations**: Standardized animation durations and curves

## Quick Start

### Import the Design System

The design system is automatically available in all SwiftUI views. No additional imports are needed.

### Basic Usage

```swift
VStack(spacing: DesignSystem.Spacing.md) {
    Text("Title")
        .heading1()
    
    Text("Body text")
        .bodyText()
    
    Button("Action") {
        // action
    }
    .textStyle(DesignSystem.Typography.button, color: .white)
    .standardPadding()
    .background(DesignSystem.Colors.primary)
    .standardCornerRadius()
}
.standardPadding()
.standardBackground()
```

## Spacing

Use consistent spacing throughout your views:

```swift
// Spacing values
DesignSystem.Spacing.xs    // 4pt
DesignSystem.Spacing.sm    // 8pt
DesignSystem.Spacing.md    // 16pt
DesignSystem.Spacing.lg    // 24pt
DesignSystem.Spacing.xl    // 32pt
DesignSystem.Spacing.xxl   // 48pt
DesignSystem.Spacing.xxxl  // 64pt

// Usage in VStack/HStack
VStack(spacing: DesignSystem.Spacing.md) { ... }
HStack(spacing: DesignSystem.Spacing.sm) { ... }
```

## Typography

Apply consistent text styles:

```swift
// Heading styles
Text("Main Title").heading1()
Text("Section Title").heading2()
Text("Subsection").heading3()
Text("Card Title").heading4()

// Body styles
Text("Regular text").bodyText()
Text("Medium weight").bodyMedium()
Text("Small text").bodySmall()

// Special styles
Text("Caption").caption()
Text("Button text").textStyle(DesignSystem.Typography.button)

// Custom colors
Text("Primary text").heading1(color: DesignSystem.Colors.primary)
Text("Secondary text").bodyText(color: DesignSystem.Colors.textSecondary)
```

## Colors

Use semantic colors for consistent theming:

```swift
// Primary colors
DesignSystem.Colors.primary
DesignSystem.Colors.primaryLight
DesignSystem.Colors.primaryDark

// Semantic colors
DesignSystem.Colors.success      // Green for success states
DesignSystem.Colors.warning      // Orange for warnings
DesignSystem.Colors.error        // Red for errors
DesignSystem.Colors.info         // Blue for information

// Neutral colors
DesignSystem.Colors.background   // Main background
DesignSystem.Colors.surface      // Card/surface background
DesignSystem.Colors.text         // Primary text
DesignSystem.Colors.textSecondary // Secondary text
DesignSystem.Colors.border       // Borders and separators

// Quiz-specific colors
DesignSystem.Colors.quizBackground
DesignSystem.Colors.correctAnswer
DesignSystem.Colors.incorrectAnswer
DesignSystem.Colors.trophy
```

## Layout Modifiers

Use consistent layout modifiers:

```swift
// Padding
.standardPadding()           // 16pt padding
.largePadding()              // 24pt padding
.extraLargePadding()         // 32pt padding
.horizontalPadding()         // 16pt horizontal padding
.verticalPadding()           // 16pt vertical padding

// Backgrounds
.standardBackground()        // System background
.surfaceBackground()         // Surface background
.quizBackground()            // Quiz-specific background

// Corner radius
.smallCornerRadius()         // 8pt radius
.standardCornerRadius()      // 12pt radius
.largeCornerRadius()         // 16pt radius

// Shadows
.smallShadow()               // Subtle shadow
.standardShadow()            // Medium shadow
```

## Animations

Use consistent animation timing:

```swift
// Animation durations
DesignSystem.Animation.fast    // 0.2s
DesignSystem.Animation.normal  // 0.3s
DesignSystem.Animation.slow    // 0.5s
DesignSystem.Animation.spring  // Spring animation

// Usage
.animation(DesignSystem.Animation.fast, value: someState)
```

## Best Practices

### 1. Always Use Design System Values

❌ **Don't do this:**
```swift
VStack(spacing: 20) {
    Text("Title")
        .font(.title)
        .foregroundColor(.blue)
}
.padding(16)
.background(Color.gray.opacity(0.1))
.cornerRadius(12)
```

✅ **Do this instead:**
```swift
VStack(spacing: DesignSystem.Spacing.lg) {
    Text("Title")
        .heading3()
}
.standardPadding()
.surfaceBackground()
.standardCornerRadius()
```

### 2. Use Semantic Colors

❌ **Don't use hardcoded colors:**
```swift
.foregroundColor(.blue)
.background(Color.red)
```

✅ **Use semantic colors:**
```swift
.foregroundColor(DesignSystem.Colors.primary)
.background(DesignSystem.Colors.error)
```

### 3. Maintain Consistent Spacing

❌ **Don't mix different spacing values:**
```swift
VStack(spacing: 16) {
    HStack(spacing: 8) { ... }
    VStack(spacing: 24) { ... }
}
```

✅ **Use consistent spacing scale:**
```swift
VStack(spacing: DesignSystem.Spacing.md) {
    HStack(spacing: DesignSystem.Spacing.sm) { ... }
    VStack(spacing: DesignSystem.Spacing.lg) { ... }
}
```

## Examples

### Card Component
```swift
struct CardView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .heading4()
            
            Text(content)
                .bodyText(color: DesignSystem.Colors.textSecondary)
        }
        .standardPadding()
        .background(DesignSystem.Colors.surface)
        .standardCornerRadius()
        .standardShadow()
    }
}
```

### Button Component
```swift
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(DesignSystem.Typography.button, color: .white)
                .frame(maxWidth: .infinity)
                .standardPadding()
                .background(DesignSystem.Colors.primary)
                .standardCornerRadius()
        }
    }
}
```

## Benefits

Using the design system provides:

1. **Consistency**: All views look cohesive and professional
2. **Maintainability**: Change colors/fonts in one place
3. **Accessibility**: Built-in support for system colors and fonts
4. **Scalability**: Easy to add new design tokens
5. **Developer Experience**: Clear, readable code with semantic meaning

## Future Enhancements

The design system can be extended with:

- Dark mode color variants
- Custom font families
- Additional animation curves
- Responsive design tokens
- Component library
- Design token export for design tools

## Support

For questions about the design system or to suggest improvements, refer to the project documentation or create an issue in the project repository.
