//
//  WelcomeViewModelTests.swift
//  SergioTests
//
//  Created by sergio jara on 24/08/25.
//

import XCTest
@testable import Sergio

@MainActor
final class WelcomeViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called before the invocation of each test method in the class.
    }

    // MARK: - WelcomeViewModel Tests
    
    func testWelcomeViewModelInitialState() throws {
        let viewModel = WelcomeViewModel()
        
        XCTAssertEqual(viewModel.userName, "")
        XCTAssertFalse(viewModel.isNameValid)
        XCTAssertFalse(viewModel.canStartQuiz)
    }
    
    func testWelcomeViewModelNameValidationValidNames() throws {
        let viewModel = WelcomeViewModel()
        
        // Test valid names (2-50 characters)
        let validNames = ["Ab", "John", "Mary Jane", String(repeating: "A", count: 50)]
        
        for name in validNames {
            viewModel.userName = name
            viewModel.validateName(name)
            XCTAssertTrue(viewModel.isNameValid, "Name '\(name)' should be valid")
            XCTAssertTrue(viewModel.canStartQuiz, "Quiz should be startable with valid name '\(name)'")
        }
    }
    
    func testWelcomeViewModelNameValidationInvalidNames() throws {
        let viewModel = WelcomeViewModel()
        
        // Test invalid names
        let invalidNames = ["", "A", String(repeating: "A", count: 51), "   ", "\n\n"]
        
        for name in invalidNames {
            viewModel.userName = name
            viewModel.validateName(name)
            XCTAssertFalse(viewModel.isNameValid, "Name '\(name)' should be invalid")
            XCTAssertFalse(viewModel.canStartQuiz, "Quiz should not be startable with invalid name '\(name)'")
        }
    }
    
    func testWelcomeViewModelNameValidationWithWhitespace() throws {
        let viewModel = WelcomeViewModel()
        
        // Test names with leading/trailing whitespace
        let namesWithWhitespace = [
            "  John  ",
            "\nMary\n",
            "   Jane   ",
            "  A  "  // Single character with whitespace
        ]
        
        for name in namesWithWhitespace {
            viewModel.userName = name
            viewModel.validateName(name)
            
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let expectedValid = trimmedName.count >= 2 && trimmedName.count <= 50
            
            XCTAssertEqual(viewModel.isNameValid, expectedValid, "Name '\(name)' validation should match trimmed result")
            XCTAssertEqual(viewModel.canStartQuiz, expectedValid, "Quiz startability should match validation result")
        }
    }
    
    func testWelcomeViewModelGetTrimmedName() throws {
        let viewModel = WelcomeViewModel()
        
        // Test trimming functionality
        let testCases = [
            ("  John  ", "John"),
            ("\nMary\n", "Mary"),
            ("   Jane   ", "Jane"),
            ("", ""),
            ("   ", ""),
            ("\n\n", ""),
            ("  A  ", "A")
        ]
        
        for (input, expected) in testCases {
            viewModel.userName = input
            let trimmed = viewModel.getTrimmedName()
            XCTAssertEqual(trimmed, expected, "Input '\(input)' should trim to '\(expected)'")
        }
    }
    
    func testWelcomeViewModelStateConsistency() throws {
        let viewModel = WelcomeViewModel()
        
        // Test that state remains consistent after validation
        viewModel.userName = "John"
        viewModel.validateName("John")
        
        XCTAssertTrue(viewModel.isNameValid)
        XCTAssertTrue(viewModel.canStartQuiz)
        
        // Change name without calling validateName
        viewModel.userName = "A"
        
        // State should remain the same until validateName is called
        XCTAssertTrue(viewModel.isNameValid)
        XCTAssertTrue(viewModel.canStartQuiz)
        
        // Now validate the new name
        viewModel.validateName("A")
        XCTAssertFalse(viewModel.isNameValid)
        XCTAssertFalse(viewModel.canStartQuiz)
    }
    
    func testWelcomeViewModelBoundaryValues() throws {
        let viewModel = WelcomeViewModel()
        
        // Test boundary values for name length
        let boundaryTests = [
            ("A", false),           // 1 character - invalid
            ("AB", true),           // 2 characters - valid
            ("ABC", true),          // 3 characters - valid
            (String(repeating: "A", count: 49), true),  // 49 characters - valid
            (String(repeating: "A", count: 50), true),  // 50 characters - valid
            (String(repeating: "A", count: 51), false)  // 51 characters - invalid
        ]
        
        for (name, expectedValid) in boundaryTests {
            viewModel.userName = name
            viewModel.validateName(name)
            XCTAssertEqual(viewModel.isNameValid, expectedValid, "Name '\(name)' (length: \(name.count)) should be \(expectedValid ? "valid" : "invalid")")
            XCTAssertEqual(viewModel.canStartQuiz, expectedValid, "Quiz startability should match validation for '\(name)'")
        }
    }
    
    func testWelcomeViewModelUnicodeCharacters() throws {
        let viewModel = WelcomeViewModel()
        
        // Test with unicode characters
        let unicodeNames = [
            "José",           // Accented character
            "Müller",         // Umlaut
            "O'Connor",       // Apostrophe
            "Jean-Pierre",    // Hyphen
            "李小明",         // Chinese name (3 characters)
            "José María",     // Multiple accented characters
            String(repeating: "A", count: 50) // 50 characters using standard String method
        ]
        
        for name in unicodeNames {
            viewModel.userName = name
            viewModel.validateName(name)
            XCTAssertTrue(viewModel.isNameValid, "Unicode name '\(name)' should be valid")
            XCTAssertTrue(viewModel.canStartQuiz, "Quiz should be startable with unicode name '\(name)'")
        }
    }
}
