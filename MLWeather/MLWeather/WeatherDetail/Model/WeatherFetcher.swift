//
//  WeatherFetcher.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// A protocol defining a weather fetcher that retrieves weather data.
protocol WeatherFetcher {
    /// Fetches weather data based on latitude and longitude.
    /// - Parameters:
    ///   - latitude: The latitude for the weather data.
    ///   - longitude: The longitude for the weather data.
    ///   - completion: A completion handler that returns a result containing either the weather data response or a network error.
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherNetworkResponse, NetworkError>) -> Void)
}
