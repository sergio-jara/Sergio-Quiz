# Dynamox iOS Technical Challenge

## Overview
This is a technical challenge submission for an iOS Developer position at Dynamox.

## Project Structure
```
dynamox/
├── App/                    # Main app entry points
├── Features/              # Feature modules (Quiz, Results, Welcome)
├── Shared/               # Common components and utilities
│   ├── DesignSystem/     # UI components and styling
│   ├── Models/          # Data models and API responses
│   ├── Networking/      # API client and storage services
│   └── Utils/          # Helper classes and extensions
└── Tests/               # Unit and UI tests
```

## Key Components

### Architecture
- **MVVM Pattern**: ViewModels handle business logic and state management
- **Coordinator Pattern**: Navigation flow management
- **Service Layer**: Abstracted networking and data persistence

### Design System
- Consistent color scheme and typography
- Reusable UI components
- Responsive layouts for different screen sizes

### Data Management
- **API Integration**: RESTful quiz question fetching
- **Local Storage**: Realm database for offline data

## Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.0+ deployment target
- CocoaPods installed

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Run `pod install`
4. Open `dynamox.xcworkspace` in Xcode
5. Build and run the project

### Running Tests
- **Unit Tests**: `Cmd + U` in Xcode
- **UI Tests**: Select UI test target and run

---
