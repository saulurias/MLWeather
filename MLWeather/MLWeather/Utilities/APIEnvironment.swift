//
//  APIEnvironment.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// An enumeration representing different API environments.
enum APIEnvironment: String {
    /// Production environment.
    case production
    /// Development environment.
    case development
    
    /// The base URL for the current environment.
    var baseURL: String {
        switch self {
        case .production:
            return "https://api.openweathermap.org/"
        case .development:
            return "https://api.openweathermap.org/"
        }
    }
    
    /// The app identifier for the current environment.
    var appId: String {
        switch self {
        case .production:
            return "d4277b87ee5c71a468ec0c3dc311a724"
        case .development:
            return "d4277b87ee5c71a468ec0c3dc311a724"
        }
    }
    
    /// The key for storing the environment in user defaults.
    static let userDefaultsKey = "API-Environment"
    /// The app group identifier.
    static let groupId = "group.com.mlweather"
    
    /// The current API environment, as stored in user defaults.
    static var current: APIEnvironment {
        return UserDefaults(suiteName: groupId)
            .flatMap { $0.string(forKey: userDefaultsKey) }
            .flatMap { APIEnvironment(rawValue: $0) } ?? .production
    }
    
    /// Sets the API environment in user defaults.
    /// - Parameter newEnvironment: The new environment to set.
    static func setEnvironment(_ newEnvironment: APIEnvironment) {
        let defaults = UserDefaults(suiteName: groupId)
        defaults?.set(newEnvironment.rawValue, forKey: userDefaultsKey)
        defaults?.synchronize()
    }
}
