//
//  WeatherDetailViewModel.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

final class WeatherDetailViewModel: ViewModel {
    
    enum State {
        case idle
        case loading
        case loaded(WeatherDetailModel)
        case error(String)
    }

    enum Action {
        case loadWeather(latitude: Double, longitude: Double)
        case weatherLoaded(WeatherDetailModel)
        case loadingFailed(String)
    }
    
    private let weatherFetcher: WeatherFetcher
    private var state: State = .idle {
        didSet {
            stateChanged?(state)
        }
    }
    
    var stateChanged: ((State) -> Void)?
    
    init(weatherFetcher: WeatherFetcher = RemoteWeatherFetcher()) {
        self.weatherFetcher = weatherFetcher
    }
    
    func send(action: Action) {
        switch action {
        case .loadWeather(let latitude, let longitude):
            loadWeather(latitude: latitude, longitude: longitude)
        case .weatherLoaded(let weatherDetailModel):
            state = .loaded(weatherDetailModel)
        case .loadingFailed(let errorMessage):
            state = .error(errorMessage)
        }
    }
    
    private func loadWeather(latitude: Double, longitude: Double) {
        state = .loading
        weatherFetcher.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherNetworkResponse):
                    let weatherDetailModel = self?.mapToWeatherDetailModel(from: weatherNetworkResponse)
                    self?.send(action: .weatherLoaded(weatherDetailModel!))
                case .failure(let error):
                    self?.send(action: .loadingFailed(error.localizedDescription))
                }
            }
        }
    }
    
    private func mapToWeatherDetailModel(from response: WeatherNetworkResponse) -> WeatherDetailModel {
        let cityName = response.name
        let weatherDescription = response.weather.first?.description.capitalized ?? "N/A"
        let temperature = "\(Int(response.main.temp - 273.15))°C"
        let highLowTemperature = "H: \(Int(response.main.tempMax - 273.15))°C  L: \(Int(response.main.tempMin - 273.15))°C"
        let wind = "Wind: \(response.wind.speed) m/s, \(response.wind.deg)°"
        let iconURL = response.weather.first.flatMap { URL(string: "https://openweathermap.org/img/wn/\($0.icon)@2x.png") }
        
        return WeatherDetailModel(
            cityName: cityName,
            weatherDescription: weatherDescription,
            temperature: temperature,
            highLowTemperature: highLowTemperature,
            wind: wind,
            iconURL: iconURL
        )
    }
}
