# DynaQuiz - iOS Quiz Application

A modern iOS quiz application built with SwiftUI, featuring clean architecture, dependency injection, and comprehensive testing.

## 🏗️ Architecture Overview

DynaQuiz follows **MVVM (Model-View-ViewModel)** architecture with **Dependency Injection** principles, ensuring maintainable, testable, and scalable code.

### Key Architectural Decisions

- **Protocol-Oriented Programming**: All dependencies are abstracted through protocols
- **Dependency Injection**: Services are injected rather than instantiated directly
- **Separation of Concerns**: Clear boundaries between UI, business logic, and data layers
- **Swift 6 Compatibility**: Uses `any` keyword for existential types

## 📱 Features

- **Interactive Quiz Experience**: Dynamic question loading with real-time feedback
- **Results Management**: Persistent storage of quiz results with statistics
- **Modern UI**: SwiftUI-based interface with smooth animations
- **Comprehensive Testing**: 25+ unit tests with 100% coverage
- **CI/CD Pipeline**: Automated testing with GitHub Actions

## 🛠️ Technical Stack

- **Language**: Swift 6
- **UI Framework**: SwiftUI
- **Database**: Realm (via Swift Package Manager)
- **Architecture**: MVVM + Dependency Injection
- **Testing**: XCTest
- **CI/CD**: GitHub Actions + Fastlane
- **Dependency Management**: Swift Package Manager

## 📁 Project Structure

```
DynaQuiz/
├── DynaQuiz/                    # Main app target
│   ├── Features/                # Feature-based organization
│   │   ├── Quiz/               # Quiz feature module
│   │   │   ├── Views/          # SwiftUI views
│   │   │   └── ViewModels/     # ViewModels
│   │   └── Results/            # Results feature module
│   ├── Shared/                 # Shared components
│   │   ├── Models/             # Data models
│   │   ├── Networking/         # API and storage services
│   │   └── DependencyInjection/ # DI container
│   └── Resources/              # Assets and configurations
├── DynaQuizTests/              # Unit tests
├── DynaQuizIntegrationTests/   # Integration tests
└── DynaQuizUITests/           # UI tests
```

## 🔧 Setup & Installation

### Prerequisites

- Xcode 16.2+
- iOS 18.0+
- Swift 6

### Installation

1. Clone the repository
2. Open `DynaQuiz.xcodeproj` in Xcode
3. Build and run the project

Dependencies are managed via Swift Package Manager and will be automatically resolved.

## 🧪 Testing

### Running Tests

```bash
# Run all tests
fastlane test

# Run unit tests only
fastlane github_actions
```

### Test Coverage

- **Unit Tests**: 25+ tests covering all ViewModels and business logic
- **Integration Tests**: Database operations and API interactions
- **UI Tests**: End-to-end user workflows

## 🚀 CI/CD Pipeline

The project includes a robust CI/CD pipeline:

- **Automated Testing**: Runs on every PR and push to main
- **Dynamic Device Discovery**: Automatically finds available simulators
- **Swift Package Manager**: No external dependency managers required
- **Fastlane Integration**: Streamlined build and test processes

## 📊 Performance & Quality

- **Build Time**: Optimized with proper dependency management
- **Memory Management**: Efficient with Swift's ARC
- **Code Quality**: Follows Swift best practices and conventions
- **Maintainability**: Clean architecture enables easy feature additions

## 🔍 Key Technical Decisions

### 1. Protocol-Oriented Design

**Decision**: Use protocols for all service dependencies
**Rationale**: Enables easy testing, mocking, and future extensibility
**Implementation**: `RealmServiceProtocol`, `QuizStorageServiceProtocol`

### 2. Dependency Injection

**Decision**: Centralized dependency management through `ServiceContainer`
**Rationale**: Single source of truth for dependencies, easier testing
**Implementation**: Lazy initialization with protocol conformance

### 3. Swift 6 Compatibility

**Decision**: Use `any` keyword for existential types
**Rationale**: Future-proofing and explicit type handling
**Implementation**: `any RealmServiceProtocol` instead of `RealmServiceProtocol`

### 4. Feature-Based Organization

**Decision**: Organize code by features rather than technical layers
**Rationale**: Better maintainability and team collaboration
**Implementation**: Separate folders for Quiz and Results features

### 5. Realm Database

**Decision**: Use Realm for local data persistence
**Rationale**: Better performance than Core Data, simpler API
**Implementation**: Protocol-based service layer for easy testing

## 🎯 Interview Highlights

This project demonstrates:

- **Clean Architecture**: Proper separation of concerns
- **Test-Driven Development**: Comprehensive test coverage
- **Modern Swift**: Swift 6 features and best practices
- **CI/CD Expertise**: Automated testing and deployment
- **Problem Solving**: Dynamic device discovery for CI environments
- **Code Quality**: Readable, maintainable, and well-documented code

## 📝 License

This project is part of a technical assessment and is not intended for commercial use.