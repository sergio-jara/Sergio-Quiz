# API Design Documentation

## Overview

DynaQuiz implements a clean, protocol-based API design that promotes testability, maintainability, and flexibility. All services are abstracted through protocols, enabling easy testing and future extensibility.

## Design Principles

### 1. Protocol-Oriented Programming
- **Abstractions First**: Define protocols before implementations
- **Interface Segregation**: Small, focused protocols
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Testability**: Easy to mock and test

### 2. Single Responsibility Principle
- **Focused APIs**: Each protocol has one clear purpose
- **Cohesive Methods**: Related functionality grouped together
- **Clear Boundaries**: Well-defined responsibilities
- **Maintainability**: Easy to understand and modify

### 3. Swift 6 Compatibility
- **Modern Swift**: Uses latest Swift features
- **Type Safety**: Strong typing with `any` keyword
- **Performance**: Optimized for Swift 6
- **Future-Proof**: Ready for Swift evolution

## Service Protocols

### RealmServiceProtocol

```swift
protocol RealmServiceProtocol {
    func getRealm() -> Realm?
    func write<T>(_ block: @escaping () -> T) -> T?
    func object<T: Object>(ofType type: T.Type, forPrimaryKey key: Any) -> T?
    func objects<T: Object>(_ type: T.Type) -> Results<T>
    func add(_ object: Object)
    func delete(_ object: Object)
    func deleteAll()
}
```

#### Design Decisions
- **Optional Realm**: Handle initialization failures gracefully
- **Generic Methods**: Type-safe operations
- **Block-based Writes**: Transaction safety
- **No ObservableObject**: Keep UI concerns separate

#### Benefits
- **Testability**: Easy to mock for unit tests
- **Flexibility**: Can swap implementations
- **Type Safety**: Compile-time error checking
- **Performance**: Optimized for Realm operations

### QuizStorageServiceProtocol

```swift
protocol QuizStorageServiceProtocol {
    func saveQuizResult(_ result: QuizResult)
    func loadQuizResults() -> [QuizResult]
    func deleteQuizResult(_ result: QuizResult)
    func clearAllResults()
}
```

#### Design Decisions
- **Domain Models**: Use business entities, not database objects
- **Array Returns**: Simple, Swift-native data structures
- **CRUD Operations**: Complete data management
- **No ObservableObject**: Keep UI concerns separate

#### Benefits
- **Abstraction**: Hide database implementation details
- **Simplicity**: Easy to use and understand
- **Consistency**: Uniform API across operations
- **Testability**: Easy to mock and test

### QuizAPIClientProtocol

```swift
protocol QuizAPIClientProtocol {
    func fetchQuestions() async throws -> [QuizQuestion]
}
```

#### Design Decisions
- **Async/Await**: Modern Swift concurrency
- **Throwing Functions**: Proper error handling
- **Array Returns**: Simple data structures
- **Single Responsibility**: Focus on API operations

#### Benefits
- **Modern Swift**: Uses latest concurrency features
- **Error Handling**: Proper error propagation
- **Simplicity**: Clear, focused API
- **Testability**: Easy to mock network calls

## Data Models

### QuizQuestion

```swift
struct QuizQuestion: Identifiable, Codable {
    let id: UUID
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var allAnswers: [String] {
        (incorrectAnswers + [correctAnswer]).shuffled()
    }
}
```

#### Design Decisions
- **Value Types**: Immutable, thread-safe
- **Computed Properties**: Derived data
- **Codable**: Easy serialization
- **Identifiable**: SwiftUI compatibility

#### Benefits
- **Immutability**: Thread-safe by default
- **Performance**: Value semantics
- **SwiftUI**: Works seamlessly with SwiftUI
- **Serialization**: Easy to persist and transmit

### QuizResult

```swift
struct QuizResult: Identifiable, Codable {
    let id: UUID
    let userName: String
    let score: Int
    let correctAnswers: Int
    let totalQuestions: Int
    let date: Date
    let questions: [QuizQuestion]
    
    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
}
```

#### Design Decisions
- **Comprehensive Data**: All necessary information
- **Computed Properties**: Derived calculations
- **Date Tracking**: Temporal information
- **Question Storage**: Complete quiz record

#### Benefits
- **Complete Records**: Full quiz history
- **Calculations**: Built-in statistics
- **Persistence**: Easy to store and retrieve
- **Analysis**: Rich data for insights

## Error Handling

### Error Types

```swift
enum QuizError: LocalizedError {
    case networkError
    case validationError(String)
    case storageError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .validationError(let message):
            return "Validation error: \(message)"
        case .storageError:
            return "Storage operation failed"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
```

#### Design Decisions
- **LocalizedError**: User-friendly error messages
- **Specific Cases**: Clear error categorization
- **Descriptive Messages**: Helpful error information
- **Swift Native**: Uses Swift error handling

#### Benefits
- **User Experience**: Clear error messages
- **Debugging**: Detailed error information
- **Maintainability**: Easy to add new error types
- **Consistency**: Uniform error handling

### Error Propagation

```swift
func fetchQuestions() async throws -> [QuizQuestion] {
    do {
        let data = try await performNetworkRequest()
        return try JSONDecoder().decode([QuizQuestion].self, from: data)
    } catch {
        throw QuizError.networkError
    }
}
```

#### Design Decisions
- **Throwing Functions**: Proper error propagation
- **Error Transformation**: Convert system errors to domain errors
- **Async/Await**: Modern error handling
- **Specific Errors**: Clear error categorization

## Dependency Injection

### ServiceContainer

```swift
class ServiceContainer {
    lazy var realmService: any RealmServiceProtocol = {
        RealmService()
    }()
    
    lazy var quizStorageService: any QuizStorageServiceProtocol = {
        QuizStorageService(realmService: realmService)
    }()
    
    lazy var quizAPIClient: any QuizAPIClientProtocol = {
        QuizAPIClient()
    }()
}
```

#### Design Decisions
- **Lazy Initialization**: Services created only when needed
- **Protocol Types**: Use `any` keyword for Swift 6
- **Dependency Chain**: Services depend on other services
- **Single Instance**: Shared instances across the app

#### Benefits
- **Performance**: Only create services when needed
- **Memory Efficiency**: Lazy loading
- **Dependency Management**: Clear dependency relationships
- **Testability**: Easy to override for testing

### ViewModel Injection

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

#### Design Decisions
- **Constructor Injection**: Dependencies provided at creation
- **Protocol Types**: Use `any` keyword
- **Immutability**: Dependencies can't be changed after creation
- **Clear Dependencies**: Explicit dependency declaration

#### Benefits
- **Testability**: Easy to inject mocks
- **Immutability**: Thread-safe dependencies
- **Clarity**: Clear dependency requirements
- **Flexibility**: Easy to swap implementations

## API Usage Examples

### ViewModel Usage

```swift
class QuizViewModel: BaseViewModel {
    @Published var currentQuestion: QuizQuestion?
    @Published var score: Int = 0
    
    private let apiClient: any QuizAPIClientProtocol
    private let storageService: any QuizStorageServiceProtocol
    
    func startQuiz() {
        Task {
            do {
                let questions = try await apiClient.fetchQuestions()
                await MainActor.run {
                    self.currentQuestion = questions.first
                }
            } catch {
                await MainActor.run {
                    self.handleError(error)
                }
            }
        }
    }
    
    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        if answer == question.correctAnswer {
            score += 1
        }
        
        // Save result
        let result = QuizResult(
            userName: "User",
            score: score,
            correctAnswers: score,
            totalQuestions: 1,
            date: Date(),
            questions: [question]
        )
        storageService.saveQuizResult(result)
    }
}
```

### Service Usage

```swift
class QuizStorageService: QuizStorageServiceProtocol {
    private let realmService: any RealmServiceProtocol
    
    init(realmService: any RealmServiceProtocol) {
        self.realmService = realmService
    }
    
    func saveQuizResult(_ result: QuizResult) {
        realmService.write { _ in
            let realmResult = RealmQuizResult(from: result)
            realmService.add(realmResult)
        }
    }
    
    func loadQuizResults() -> [QuizResult] {
        guard let realm = realmService.getRealm() else { return [] }
        
        let realmResults = realm.objects(RealmQuizResult.self)
        return realmResults.map { QuizResult(from: $0) }
    }
}
```

## Testing Support

### Mock Implementations

```swift
class MockQuizAPIClient: QuizAPIClientProtocol {
    var shouldReturnError = false
    var mockQuestions: [QuizQuestion] = []
    
    func fetchQuestions() async throws -> [QuizQuestion] {
        if shouldReturnError {
            throw QuizError.networkError
        }
        return mockQuestions
    }
}

class MockQuizStorageService: QuizStorageServiceProtocol {
    private var results: [QuizResult] = []
    
    func saveQuizResult(_ result: QuizResult) {
        results.append(result)
    }
    
    func loadQuizResults() -> [QuizResult] {
        return results
    }
    
    func deleteQuizResult(_ result: QuizResult) {
        results.removeAll { $0.id == result.id }
    }
    
    func clearAllResults() {
        results.removeAll()
    }
}
```

#### Benefits
- **Test Isolation**: Tests don't depend on external systems
- **Controlled Behavior**: Predictable test scenarios
- **Fast Execution**: No network or database operations
- **Error Testing**: Easy to test error conditions

## Performance Considerations

### Memory Management
- **Value Types**: Structs for data models
- **Weak References**: Prevent retain cycles
- **Lazy Loading**: Load data only when needed
- **ARC Compliance**: Proper memory management

### Network Performance
- **Async/Await**: Non-blocking network operations
- **Error Handling**: Proper error recovery
- **Caching**: Cache frequently accessed data
- **Background Threading**: Keep UI responsive

### Database Performance
- **Realm Benefits**: Better performance than Core Data
- **Batch Operations**: Efficient data operations
- **Background Threading**: Non-blocking database operations
- **Memory Efficiency**: Lazy loading of data

## Future Extensibility

### Adding New Services
1. Define protocol with required methods
2. Create implementation class
3. Add to ServiceContainer
4. Inject into ViewModels
5. Add comprehensive tests

### Modifying Existing APIs
1. Update protocol with new methods
2. Update implementation classes
3. Update ViewModels to use new functionality
4. Update tests
5. Update documentation

### API Versioning
- **Backward Compatibility**: Maintain existing APIs
- **Deprecation**: Mark old APIs as deprecated
- **Migration**: Provide migration paths
- **Documentation**: Clear versioning information

## Conclusion

The API design for DynaQuiz provides:
- **Clean Architecture**: Well-organized, maintainable code
- **Testability**: Easy to test and mock
- **Flexibility**: Easy to extend and modify
- **Performance**: Optimized for iOS development
- **Modern Swift**: Uses latest Swift features and best practices

This API design ensures a solid foundation for a production-ready iOS application that can evolve and grow over time.
