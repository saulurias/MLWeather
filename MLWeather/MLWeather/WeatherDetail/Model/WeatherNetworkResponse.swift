//
//  WeatherResponse.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

struct WeatherNetworkResponse: Codable {
    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }

    struct Clouds: Codable {
        let all: Int
    }

    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
