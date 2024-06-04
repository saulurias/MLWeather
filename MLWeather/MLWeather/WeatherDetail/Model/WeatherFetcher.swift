//
//  WeatherFetcher.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

protocol WeatherFetcher {
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherNetworkResponse, NetworkError>) -> Void)
}
