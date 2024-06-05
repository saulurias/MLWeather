//
//  WeatherDetailViewModelTests.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest
@testable import MLWeather

class WeatherDetailViewModelTests: XCTestCase {
    var weatherFetcher: MockWeatherFetcher!
    var viewModel: WeatherDetailViewModel!
    
    override func setUp() {
        super.setUp()
        weatherFetcher = MockWeatherFetcher()
        viewModel = WeatherDetailViewModel(weatherFetcher: weatherFetcher)
    }
    
    override func tearDown() {
        viewModel = nil
        weatherFetcher = nil
        super.tearDown()
    }
    
    func test_initialState_isIdle() {
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func test_loadWeather_setsStateToLoading() {
        let expectation = self.expectation(description: "State changed to loading")
        
        viewModel.stateChanged = { state in
            if case .loading = state {
                expectation.fulfill()
            }
        }
        
        viewModel.send(action: .loadWeather(latitude: 34.0194, longitude: -118.4912))
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_loadWeather_successfulResponse_setsStateToLoaded() {
        let expectation = self.expectation(description: "State changed to loaded")
        
        let mockResponse = WeatherNetworkResponse(
            coord: WeatherNetworkResponse.Coordinates(lon: -118.4912, lat: 34.0194),
            weather: [WeatherNetworkResponse.Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            base: "stations",
            main: WeatherNetworkResponse.Main(temp: 298.15, feelsLike: 298.15, tempMin: 296.15, tempMax: 300.15, pressure: 1013, humidity: 40),
            visibility: 10000,
            wind: WeatherNetworkResponse.Wind(speed: 3.6, deg: 250),
            clouds: WeatherNetworkResponse.Clouds(all: 1),
            dt: 1605182400,
            timezone: -28800,
            id: 5392171,
            name: "Santa Monica",
            cod: 200
        )
        
        weatherFetcher.result = .success(mockResponse)
        
        viewModel.stateChanged = { state in
            if case .loaded(let weatherDetailModel) = state {
                XCTAssertEqual(weatherDetailModel.cityName, "Santa Monica")
                XCTAssertEqual(weatherDetailModel.weatherDescription, "Clear Sky")
                XCTAssertEqual(weatherDetailModel.temperature, "25°C") // 298.15K - 273.15 = 25°C
                XCTAssertEqual(weatherDetailModel.highLowTemperature, "H: 27°C  L: 23°C")
                XCTAssertEqual(weatherDetailModel.wind, "Wind: 3.6 m/s, 250°")
                expectation.fulfill()
            }
        }
        
        viewModel.send(action: .loadWeather(latitude: 34.0194, longitude: -118.4912))
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_loadWeather_failureResponse_setsStateToError() {
        let expectation = self.expectation(description: "State changed to error")
        
        weatherFetcher.result = .failure(NetworkError.invalidResponse)
        
        viewModel.stateChanged = { state in
            if case .error(let errorMessage) = state {
                XCTAssertEqual(errorMessage, NetworkError.invalidResponse.localizedDescription)
                expectation.fulfill()
            }
        }
        
        viewModel.send(action: .loadWeather(latitude: 34.0194, longitude: -118.4912))
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// Mock WeatherFetcher
class MockWeatherFetcher: WeatherFetcher {
    var result: Result<WeatherNetworkResponse, NetworkError>?
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherNetworkResponse, NetworkError>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
