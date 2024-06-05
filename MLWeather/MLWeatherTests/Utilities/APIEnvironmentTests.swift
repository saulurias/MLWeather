//
//  APIEnvironmentTests.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest
@testable import MLWeather

class APIEnvironmentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset the user defaults to ensure tests are isolated
        let defaults = UserDefaults(suiteName: "test-group-id")
        defaults?.removeObject(forKey: "test-key")
        defaults?.synchronize()
    }

    override func tearDown() {
        // Clean up the user defaults after each test
        let defaults = UserDefaults(suiteName: "test-group-id")
        defaults?.removeObject(forKey: "test-key")
        defaults?.synchronize()
        super.tearDown()
    }
    
    func testBaseURL() {
        XCTAssertEqual(APIEnvironment.production.baseURL, "https://api.openweathermap.org/")
        XCTAssertEqual(APIEnvironment.development.baseURL, "https://api.openweathermap.org/")
    }

    func testAppId() {
        XCTAssertEqual(APIEnvironment.production.appId, "YOUR_API_KEY")
        XCTAssertEqual(APIEnvironment.development.appId, "YOUR_API_KEY")
    }

    func test_currentEnvironment_default() {
        // By default, the current environment should be production
        XCTAssertEqual(APIEnvironment.current, .production)
    }

    func test_setEnvironment() {
        // Change environment to development
        APIEnvironment.setEnvironment(.development)
        XCTAssertEqual(APIEnvironment.current, .development)

        // Change environment to production
        APIEnvironment.setEnvironment(.production)
        XCTAssertEqual(APIEnvironment.current, .production)
    }
}
