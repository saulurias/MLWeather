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
        case loaded(WeatherResponse)
        case error(String)
    }

    enum Action {
        case loadWeather
        case weatherLoaded(WeatherResponse)
        case loadingFailed(String)
    }
    
    private let apiRequester: APIRequester
    private var state: State = .idle {
        didSet {
            stateChanged?(state)
        }
    }
    
    var stateChanged: ((State) -> Void)?
    
    init(apiRequester: APIRequester = APIRequester()) {
        self.apiRequester = apiRequester
    }
    
    func send(action: Action) {
        switch action {
        case .loadWeather:
            loadWeather()
        case .weatherLoaded(let weatherResponse):
            state = .loaded(weatherResponse)
        case .loadingFailed(let errorMessage):
            state = .error(errorMessage)
        }
    }
    
    private func loadWeather() {
        state = .loading
        let weatherRequest = WeatherRequest.fetchWeather(latitude: 34.0194704, longitude: -118.4912273)
        apiRequester.performRequest(with: weatherRequest) { [weak self] (result: Result<WeatherResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self?.send(action: .weatherLoaded(weatherResponse))
                case .failure(let error):
                    self?.send(action: .loadingFailed(error.localizedDescription))
                }
            }
        }
    }
}
