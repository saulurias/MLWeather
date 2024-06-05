//
//  MockLocationManagerDelegate.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest
import CoreLocation
@testable import MLWeather

class MockLocationManagerDelegate: LocationManagerDelegate {
    var didUpdateLocationCalled = false
    var didFailWithErrorCalled = false
    var receivedLatitude: Double?
    var receivedLongitude: Double?
    var receivedError: Error?

    func didUpdateLocation(latitude: Double, longitude: Double) {
        didUpdateLocationCalled = true
        receivedLatitude = latitude
        receivedLongitude = longitude
    }

    func didFailWithError(error: Error) {
        didFailWithErrorCalled = true
        receivedError = error
    }
}
