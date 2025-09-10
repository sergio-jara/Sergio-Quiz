//
//  TestUtilities.swift
//  SergioIntegrationTests
//
//  Created by sergio jara on 05/09/25.
//

import XCTest

// MARK: - Test Utilities
extension XCTestCase {
    
    func expectAsync<T>(
        _ expression: @escaping () async throws -> T,
        toThrow expectedError: Error,
        timeout: TimeInterval = 1.0
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error \(expectedError) but got success")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func measureAsync<T>(
        _ block: @escaping () async throws -> T
    ) async throws -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await block()
        let time = CFAbsoluteTimeGetCurrent() - startTime
        return (result, time)
    }
}
