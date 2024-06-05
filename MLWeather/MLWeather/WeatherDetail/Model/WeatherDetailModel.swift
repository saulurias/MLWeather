//
//  WeatherDetailModel.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

struct WeatherDetailModel: Equatable {
    let cityName: String
    let weatherDescription: String
    let temperature: String
    let highLowTemperature: String
    let wind: String
    let iconURL: URL?

    static func == (lhs: WeatherDetailModel, rhs: WeatherDetailModel) -> Bool {
        return lhs.cityName == rhs.cityName &&
               lhs.weatherDescription == rhs.weatherDescription &&
               lhs.temperature == rhs.temperature &&
               lhs.highLowTemperature == rhs.highLowTemperature &&
               lhs.wind == rhs.wind &&
               lhs.iconURL == rhs.iconURL
    }
}
