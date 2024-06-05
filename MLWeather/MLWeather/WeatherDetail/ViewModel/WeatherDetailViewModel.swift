//
//  WeatherDetailViewModel.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// A ViewModel that handles the state and actions for weather details.
final class WeatherDetailViewModel: ViewModel {
    
    // MARK: - State
    /// Represents the various states the ViewModel can be in.
    enum State: Equatable {
        case idle
        case loading
        case loaded(WeatherDetailModel)
        case error(String)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading):
                return true
            case (.loaded(let lhsModel), .loaded(let rhsModel)):
                return lhsModel == rhsModel
            case (.error(let lhsMessage), .error(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
    }

    // MARK: - Action
    /// Represents the actions that can be sent to the ViewModel.
    enum Action {
        case loadWeather(latitude: Double, longitude: Double)
        case weatherLoaded(WeatherDetailModel)
        case loadingFailed(String)
    }
    
    // MARK: - Properties
    private let weatherFetcher: WeatherFetcher
    var state: State = .idle {
        didSet {
            stateChanged?(state)
        }
    }
    
    /// A closure that gets called whenever the state changes.
    var stateChanged: ((State) -> Void)?
    
    // MARK: - Initialization
    /// Initializes a new instance of `WeatherDetailViewModel`.
    /// - Parameter weatherFetcher: The fetcher used to retrieve weather data. Defaults to `RemoteWeatherFetcher`.
    init(weatherFetcher: WeatherFetcher = RemoteWeatherFetcher()) {
        self.weatherFetcher = weatherFetcher
    }
    
    // MARK: - Public Methods
    /// Sends an action to the ViewModel.
    /// - Parameter action: The action to be sent.
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
    
    // MARK: - Private Methods
    private func loadWeather(latitude: Double, longitude: Double) {
        state = .loading
        weatherFetcher.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherNetworkResponse):
                    if let weatherDetailModel = self?.mapToWeatherDetailModel(from: weatherNetworkResponse) {
                        self?.send(action: .weatherLoaded(weatherDetailModel))
                    }
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
