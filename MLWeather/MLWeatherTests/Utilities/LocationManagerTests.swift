//
//  LocationManagerTests.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest
import CoreLocation
@testable import MLWeather

class LocationManagerTests: XCTestCase {
    var locationManager: LocationManager!
    var mockDelegate: MockLocationManagerDelegate!
    
    override func setUp() {
        super.setUp()
        locationManager = LocationManager()
        mockDelegate = MockLocationManagerDelegate()
        locationManager.delegate = mockDelegate
    }
    
    override func tearDown() {
        locationManager = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_DidUpdateLocation() {
        // Create a CLLocation object with test coordinates
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        // Call the delegate method directly
        locationManager.locationManager(CLLocationManager(), didUpdateLocations: [testLocation])
        
        // Assert that the delegate method was called with the correct coordinates
        XCTAssertTrue(mockDelegate.didUpdateLocationCalled)
        XCTAssertEqual(mockDelegate.receivedLatitude, 37.7749)
        XCTAssertEqual(mockDelegate.receivedLongitude, -122.4194)
    }
    
    func test_DidFailWithError() {
        // Create a test error
        let testError = NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        
        // Call the delegate method directly
        locationManager.locationManager(CLLocationManager(), didFailWithError: testError)
        
        // Assert that the delegate method was called with the correct error
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertEqual(mockDelegate.receivedError as NSError?, testError)
    }
}
