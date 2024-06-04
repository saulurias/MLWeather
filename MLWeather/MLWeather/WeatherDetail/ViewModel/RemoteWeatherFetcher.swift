//
//  RemoteWeatherFetcher.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

final class RemoteWeatherFetcher: WeatherFetcher {
    private let apiRequester: APIRequester

    init(apiRequester: APIRequester = APIRequester()) {
        self.apiRequester = apiRequester
    }

    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherNetworkResponse, NetworkError>) -> Void) {
        let weatherRequest = WeatherRequest.fetchWeather(latitude: latitude, longitude: longitude)
        apiRequester.performRequest(with: weatherRequest, completion: completion)
    }
}
