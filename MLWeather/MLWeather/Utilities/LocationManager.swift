//
//  LocationManager.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation
import CoreLocation

/// A protocol defining the delegate methods for location updates and errors.
protocol LocationManagerDelegate: AnyObject {
    /// Called when the location is successfully updated.
    /// - Parameters:
    ///   - latitude: The updated latitude.
    ///   - longitude: The updated longitude.
    func didUpdateLocation(latitude: Double, longitude: Double)
    
    /// Called when there is an error updating the location.
    /// - Parameter error: The error encountered.
    func didFailWithError(error: Error)
}

/// A class that manages location updates using `CLLocationManager`.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Requests the user's location.
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    /// Delegate method called when the location manager updates locations.
    /// - Parameters:
    ///   - manager: The location manager providing the update.
    ///   - locations: An array of `CLLocation` objects representing the updated locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    /// Delegate method called when the location manager fails with an error.
    /// - Parameters:
    ///   - manager: The location manager reporting the error.
    ///   - error: The error encountered.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
