//
//  WelcomeViewUITests.swift
//  dynamoxUITests
//
//  Created by sergio jara on 24/08/25.
//

import XCTest

@MainActor
final class WelcomeViewUITests: XCTestCase {
    
    // MARK: - Properties
    private var app: XCUIApplication!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Create and launch the app once for all tests
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Clean up if needed
        app = nil
    }
    
    // MARK: - WelcomeView UI Tests
    
    func testWelcomeViewInitialDisplay() throws {
        // Test initial display of welcome screen using actual text from DesignSystem
        XCTAssertTrue(app.staticTexts["Welcome to Dynamox Quiz!"].exists)
        XCTAssertTrue(app.staticTexts["Test your knowledge with our interactive quiz"].exists)
        XCTAssertTrue(app.staticTexts["Please enter your name to begin"].exists)
        XCTAssertTrue(app.staticTexts["Ready to challenge yourself?"].exists)
        XCTAssertTrue(app.staticTexts["10 questions • Multiple choice • Instant feedback"].exists)
    }
    
    func testWelcomeViewUIElements() throws {
        // Test that all UI elements are present
        let welcomeText = app.staticTexts["Welcome to Dynamox Quiz!"]
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        XCTAssertTrue(welcomeText.exists)
        XCTAssertTrue(nameTextField.exists)
        XCTAssertTrue(startButton.exists)
        
        // Test element properties
        XCTAssertFalse(startButton.isEnabled, "Start button should be initially disabled")
        XCTAssertFalse(startButton.isSelected)
    }
    
    func testWelcomeViewNameInputValidation() throws {
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Test valid name input
        nameTextField.tap()
        nameTextField.typeText("John")
        
        // Button should be enabled with valid name
        XCTAssertTrue(startButton.isEnabled)
    }
    
    func testWelcomeViewNameValidationError() throws {
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Test invalid name input (too short)
        nameTextField.tap()
        nameTextField.typeText("A")
        
        // Button should be disabled with invalid name
        XCTAssertFalse(startButton.isEnabled)
        
        // Validation error should appear
        let errorText = app.staticTexts["Name must be between 2 and 50 characters"]
        XCTAssertTrue(errorText.exists)
    }
    
    func testWelcomeViewNameInputWithWhitespace() throws {
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Test name with leading/trailing whitespace
        nameTextField.tap()
        nameTextField.typeText("  Jane  ")
        
        // Button should be enabled (whitespace should be trimmed)
        XCTAssertTrue(startButton.isEnabled)
    }
    
    func testWelcomeViewNameInputMaxLength() throws {
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Test name at maximum length (50 characters)
        let longName = String(repeating: "A", count: 50)
        nameTextField.tap()
        nameTextField.typeText(longName)
        
        // Button should be enabled
        XCTAssertTrue(startButton.isEnabled)
        
        // Test name exceeding maximum length
        nameTextField.tap()
        nameTextField.typeText("B")
        
        // Button should be disabled
        XCTAssertFalse(startButton.isEnabled)
    }
    
    func testWelcomeViewButtonStateChanges() throws {
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Initially button should be disabled
        XCTAssertFalse(startButton.isEnabled)
        
        // Type valid name
        nameTextField.tap()
        nameTextField.typeText("John")
        
        // Button should become enabled with valid name
        XCTAssertTrue(startButton.isEnabled)
        
        // Clear text and type invalid name
        nameTextField.doubleTap() // Select all text
        nameTextField.typeText("A")
        
        // Button should become disabled again with invalid name
        XCTAssertFalse(startButton.isEnabled)
    }
    
    func testWelcomeViewTextFieldFocus() throws {
        let nameTextField = app.textFields["Your name"]
        
        // Test text field can receive input
        nameTextField.tap()
        nameTextField.typeText("Test Input")
        
        // Verify the text field accepts input
        XCTAssertEqual(nameTextField.value as? String, "Test Input")
    }
    
    
    func testWelcomeViewAccessibility() throws {
        // Test accessibility labels and hints
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Verify elements exist and are accessible
        XCTAssertTrue(nameTextField.exists, "Name text field should be accessible")
        XCTAssertTrue(startButton.exists, "Start button should be accessible")
        
        // Test that elements can be identified by their text content
        let welcomeText = app.staticTexts["Welcome to Dynamox Quiz!"]
        XCTAssertTrue(welcomeText.exists, "Welcome text should be accessible")
        
        // Test that elements respond to accessibility actions
        XCTAssertTrue(nameTextField.isEnabled, "Name text field should be enabled for accessibility")
        XCTAssertFalse(startButton.isEnabled, "Start button should be initially disabled for accessibility")
    }
    
    func testWelcomeViewDesignSystemConsistency() throws {
        // Test that design system constants are properly applied
        let welcomeText = app.staticTexts["Welcome to Dynamox Quiz!"]
        let nameTextField = app.textFields["Your name"]
        let startButton = app.buttons["Start Quiz"]
        
        // Verify all elements exist and are properly styled
        XCTAssertTrue(welcomeText.exists)
        XCTAssertTrue(nameTextField.exists)
        XCTAssertTrue(startButton.exists)
        
        // Test that the brain icon is displayed
        let brainIcon = app.images["brain.head.profile"]
        XCTAssertTrue(brainIcon.exists, "Brain icon should be displayed according to design system")
        
        // Test that the play icon is displayed in the button
        let playIcon = app.images["play.fill"]
        XCTAssertTrue(playIcon.exists, "Play icon should be displayed in button according to design system")
    }
}

// MARK: - XCUIElement Extensions for Testing
extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and type text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
