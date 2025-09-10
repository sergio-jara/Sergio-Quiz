//
//  DynaQuizUITests.swift
//  DynaQuizUITests
//
//  Created by sergio jara on 23/08/25.
//

import XCTest

@MainActor
final class DynaQuizUITests: XCTestCase {
    
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

    func testExample() throws {
        // Basic test to ensure the UI test suite is working
        XCTAssertTrue(app.exists, "App should launch successfully")
    }

    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
