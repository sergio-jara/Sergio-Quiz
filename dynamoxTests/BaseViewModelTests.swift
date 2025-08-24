//
//  BaseViewModelTests.swift
//  dynamoxTests
//
//  Created by sergio jara on 24/08/25.
//

import XCTest
@testable import dynamox

@MainActor
final class BaseViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called before the invocation of each test method in the class.
    }

    // MARK: - BaseViewModel Tests
    
    func testBaseViewModelInitialState() throws {
        let viewModel = BaseViewModel()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testBaseViewModelLoadingState() throws {
        let viewModel = BaseViewModel()
        
        // Test setting loading state
        viewModel.setLoading(true)
        XCTAssertTrue(viewModel.isLoading)
        
        viewModel.setLoading(false)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testBaseViewModelErrorHandling() throws {
        let viewModel = BaseViewModel()
        
        // Test handling generic error
        let genericError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        viewModel.handleError(genericError)
        
        XCTAssertEqual(viewModel.errorMessage, "Test error")
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testBaseViewModelClearError() throws {
        let viewModel = BaseViewModel()
        
        // Set error state
        viewModel.errorMessage = "Test error"
        viewModel.showError = true
        
        // Clear error
        viewModel.clearError()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
}
