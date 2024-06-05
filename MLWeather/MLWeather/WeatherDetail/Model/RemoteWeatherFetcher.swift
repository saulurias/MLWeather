//
//  RemoteWeatherFetcher.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// A class that fetches weather data from a remote source.
final class RemoteWeatherFetcher: WeatherFetcher {
    private let apiRequester: APIRequester

    /// Initializes a new instance of `RemoteWeatherFetcher`.
    /// - Parameter apiRequester: The requester used to perform API requests. Defaults to a new instance of `APIRequester`.
    init(apiRequester: APIRequester = APIRequester()) {
        self.apiRequester = apiRequester
    }

    /// Fetches weather data based on latitude and longitude.
    /// - Parameters:
    ///   - latitude: The latitude for the weather data.
    ///   - longitude: The longitude for the weather data.
    ///   - completion: A completion handler that returns a result containing either the weather data response or a network error.
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherNetworkResponse, NetworkError>) -> Void) {
        let weatherRequest = WeatherRequest.fetchWeather(latitude: latitude, longitude: longitude)
        apiRequester.performRequest(with: weatherRequest, completion: completion)
    }
}
