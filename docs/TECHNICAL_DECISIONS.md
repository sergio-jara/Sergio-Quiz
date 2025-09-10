# Technical Decisions Documentation

## Overview

This document outlines the key technical decisions made during the development of DynaQuiz, including rationale, alternatives considered, and implementation details.

## 1. Architecture Pattern: MVVM with Dependency Injection

### Decision
Chose **MVVM (Model-View-ViewModel)** with **Dependency Injection** over other patterns like MVC or VIPER.

### Rationale
- **Testability**: ViewModels can be easily unit tested without UI dependencies
- **Separation of Concerns**: Clear boundaries between UI and business logic
- **SwiftUI Compatibility**: MVVM works naturally with SwiftUI's reactive nature
- **Team Familiarity**: MVVM is widely understood and adopted

### Alternatives Considered
- **MVC**: Too tightly coupled, difficult to test
- **VIPER**: Over-engineered for this app's complexity
- **TCA (The Composable Architecture)**: Too complex for current requirements

### Implementation
```swift
class QuizViewModel: BaseViewModel {
    private let apiClient: any QuizAPIClientProtocol
    private let storageService: any QuizStorageServiceProtocol
    
    init(apiClient: any QuizAPIClientProtocol, 
         storageService: any QuizStorageServiceProtocol) {
        self.apiClient = apiClient
        self.storageService = storageService
    }
}
```

## 2. Dependency Management: Swift Package Manager

### Decision
Used **Swift Package Manager (SPM)** instead of CocoaPods or Carthage.

### Rationale
- **Native Integration**: Built into Xcode, no external tools needed
- **Performance**: Faster dependency resolution and builds
- **Maintenance**: Less configuration and fewer files to manage
- **Future-Proof**: Apple's recommended solution

### Migration Process
1. Removed CocoaPods completely (`pod deintegrate`)
2. Cleaned project file of CocoaPods references
3. Added RealmSwift via Xcode's Package Manager UI
4. Updated CI/CD to remove CocoaPods steps

### Benefits Realized
- **Faster CI**: No `pod install` step required
- **Cleaner Project**: Fewer configuration files
- **Better Integration**: Seamless Xcode integration

## 3. Database: Realm over Core Data

### Decision
Chose **Realm** over Core Data for local data persistence.

### Rationale
- **Performance**: Faster read/write operations
- **Simplicity**: Easier API and less boilerplate code
- **Swift Integration**: Better Swift support than Core Data
- **Migration**: Simpler schema migration process

### Implementation
```swift
class RealmService: RealmServiceProtocol {
    private let realm: Realm?
    
    init() {
        do {
            realm = try Realm()
        } catch {
            realm = nil
        }
    }
}
```

### Trade-offs
- **File Size**: Larger app bundle due to Realm framework
- **Vendor Lock-in**: Less portable than Core Data
- **Learning Curve**: Team needs to learn Realm-specific APIs

## 4. Swift 6 Compatibility: Using `any` Keyword

### Decision
Adopted Swift 6's `any` keyword for existential types.

### Rationale
- **Future-Proofing**: Prepares code for Swift 6 migration
- **Explicit Types**: Makes existential types more obvious
- **Performance**: Better optimization opportunities
- **Code Clarity**: Clearer intent when using protocols

### Implementation
```swift
// Before (Swift 5)
private let realmService: RealmServiceProtocol

// After (Swift 6)
private let realmService: any RealmServiceProtocol
```

### Impact
- **Compilation**: Requires Xcode 15+ and Swift 6
- **Readability**: More explicit about type erasure
- **Performance**: Better compiler optimizations

## 5. Protocol Design: No ObservableObject in Protocols

### Decision
Removed `ObservableObject` conformance from service protocols.

### Rationale
- **Interface Segregation Principle**: Protocols shouldn't force UI concerns
- **Flexibility**: Services can be used in non-UI contexts
- **Testing**: Easier to mock and test services
- **Separation of Concerns**: UI reactivity is a UI concern

### Implementation
```swift
// Protocol (no ObservableObject)
protocol RealmServiceProtocol {
    func getRealm() -> Realm?
    // ... other methods
}

// Implementation (with ObservableObject if needed)
class RealmService: RealmServiceProtocol, ObservableObject {
    // ... implementation
}
```

### Benefits
- **Cleaner Protocols**: Focus on core functionality
- **Better Testing**: Easier to create test doubles
- **Flexibility**: Services can be used anywhere

## 6. CI/CD: Dynamic Device Discovery

### Decision
Implemented dynamic simulator discovery instead of hardcoded device names.

### Problem
GitHub Actions CI environment has different available simulators than local development.

### Solution
```ruby
# Dynamic device discovery
destinations = sh("xcodebuild -project ../DynaQuiz.xcodeproj -scheme DynaQuiz -showdestinations | grep 'platform:iOS Simulator' | grep 'iPhone' | head -1", log: false)

# Extract UDID from destination
device_match = destinations.match(/id:([A-F0-9-]+)/)
device_udid = device_match[1]

# Use discovered device
sh("xcodebuild test -project ../DynaQuiz.xcodeproj -scheme DynaQuiz -destination 'platform=iOS Simulator,id=#{device_udid}' -only-testing:DynaQuizTests")
```

### Benefits
- **Reliability**: Works across different CI environments
- **Maintainability**: No need to update hardcoded device names
- **Flexibility**: Adapts to available simulators

## 7. Error Handling Strategy

### Decision
Implemented centralized error handling with user-friendly messages.

### Rationale
- **User Experience**: Clear, actionable error messages
- **Debugging**: Detailed error information for developers
- **Consistency**: Uniform error handling across the app

### Implementation
```swift
class BaseViewModel: ObservableObject {
    @Published var errorMessage: String?
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        isLoading = false
    }
}
```

### Error Types
- **Network Errors**: API communication failures
- **Validation Errors**: Input validation failures
- **Storage Errors**: Database operation failures
- **Business Logic Errors**: Domain-specific errors

## 8. Testing Strategy: Comprehensive Unit Testing

### Decision
Implemented 25+ unit tests covering all ViewModels and business logic.

### Rationale
- **Quality Assurance**: Catch bugs before production
- **Refactoring Safety**: Enable confident code changes
- **Documentation**: Tests serve as living documentation
- **CI/CD Integration**: Automated quality checks

### Test Structure
```swift
class QuizViewModelTests: XCTestCase {
    private var viewModel: QuizViewModel!
    private var mockAPIClient: MockQuizAPIClient!
    private var mockStorageService: MockQuizStorageService!
    
    override func setUp() {
        mockAPIClient = MockQuizAPIClient()
        mockStorageService = MockQuizStorageService()
        viewModel = QuizViewModel(apiClient: mockAPIClient, 
                                 storageService: mockStorageService)
    }
}
```

### Coverage Areas
- **ViewModels**: All business logic and state management
- **Services**: Data operations and API interactions
- **Models**: Data transformations and validations
- **Edge Cases**: Boundary conditions and error scenarios

## 9. Code Organization: Feature-Based Structure

### Decision
Organized code by features rather than technical layers.

### Rationale
- **Maintainability**: Related code is co-located
- **Team Collaboration**: Easier for multiple developers
- **Scalability**: Easy to add new features
- **Understanding**: Clear feature boundaries

### Structure
```
Features/
├── Quiz/
│   ├── Views/
│   ├── ViewModels/
│   └── Models/
└── Results/
    ├── Views/
    ├── ViewModels/
    └── Models/
```

### Benefits
- **Feature Isolation**: Changes are contained within features
- **Easy Navigation**: Developers can find related code quickly
- **Modularity**: Features can be developed independently

## 10. State Management: SwiftUI + @Published

### Decision
Used SwiftUI's built-in state management with `@Published` properties.

### Rationale
- **Simplicity**: No external state management libraries needed
- **Performance**: Optimized for SwiftUI
- **Maintainability**: Less complexity and fewer dependencies
- **Native Integration**: Works seamlessly with SwiftUI

### Implementation
```swift
class QuizViewModel: BaseViewModel {
    @Published var currentQuestion: QuizQuestion?
    @Published var selectedAnswer: String?
    @Published var score: Int = 0
    @Published var isQuizCompleted: Bool = false
}
```

### Benefits
- **Reactive UI**: Automatic UI updates when state changes
- **Type Safety**: Compile-time checking of state changes
- **Performance**: Efficient re-rendering only when needed

## 11. Navigation: SwiftUI NavigationView

### Decision
Used SwiftUI's native navigation instead of external navigation libraries.

### Rationale
- **Simplicity**: No additional dependencies
- **Performance**: Native SwiftUI performance
- **Maintainability**: Less complexity
- **Future-Proof**: Will benefit from SwiftUI improvements

### Implementation
```swift
NavigationView {
    WelcomeView()
        .navigationDestination(isPresented: $showQuiz) {
            QuizView()
        }
        .navigationDestination(isPresented: $showResults) {
            ResultsView()
        }
}
```

## 12. API Design: Protocol-Based Services

### Decision
Created protocol-based API services for better testability and flexibility.

### Rationale
- **Testability**: Easy to mock for unit tests
- **Flexibility**: Can swap implementations easily
- **Maintainability**: Clear contracts between components
- **SOLID Principles**: Follows dependency inversion principle

### Implementation
```swift
protocol QuizAPIClientProtocol {
    func fetchQuestions() async throws -> [QuizQuestion]
}

class QuizAPIClient: QuizAPIClientProtocol {
    func fetchQuestions() async throws -> [QuizQuestion] {
        // Implementation
    }
}
```

## Conclusion

These technical decisions were made to create a maintainable, testable, and scalable iOS application. Each decision was carefully considered with alternatives evaluated, and the rationale documented for future reference and team understanding.

The combination of these decisions results in a codebase that is:
- **Easy to test** with comprehensive unit test coverage
- **Easy to maintain** with clear separation of concerns
- **Easy to extend** with protocol-based architecture
- **Easy to understand** with well-documented decisions
