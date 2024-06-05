//
//  APIRequesterTests.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest
@testable import MLWeather

class APIRequesterTests: XCTestCase {
    var apiRequester: APIRequester!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        apiRequester = APIRequester(session: session)
    }

    override func tearDown() {
        apiRequester = nil
        session = nil
        super.tearDown()
    }

    func test_performRequest_successfulResponse() {
        let expectation = self.expectation(description: "Successful response")
        let mockData = """
            {
                "coord": {"lon": -118.4912, "lat": 34.0194},
                "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
                "base": "stations",
                "main": {"temp": 298.15, "feels_like": 298.15, "temp_min": 296.15, "temp_max": 300.15, "pressure": 1013, "humidity": 40},
                "visibility": 10000,
                "wind": {"speed": 3.6, "deg": 250},
                "clouds": {"all": 1},
                "dt": 1605182400,
                "timezone": -28800,
                "id": 5392171,
                "name": "Santa Monica",
                "cod": 200
            }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData)
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, "Santa Monica")
                XCTAssertEqual(response.weather.first?.icon, "01d")
                XCTAssertEqual(response.weather.first?.description, "clear sky")
                XCTAssertEqual(response.main.temp, 298.15)
                XCTAssertEqual(response.main.tempMin, 296.15)
                XCTAssertEqual(response.main.tempMax, 300.15)
                XCTAssertEqual(response.wind.speed, 3.6)
                XCTAssertEqual(response.wind.deg, 250)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected successful response")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_performRequest_networkError() {
        let expectation = self.expectation(description: "Network error")

        MockURLProtocol.requestHandler = { request in
            throw URLError(.notConnectedToInternet)
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected network error")
            case .failure(let error):
                if case .networkError(let networkError) = error {
                    XCTAssertEqual((networkError as? URLError)?.code, .notConnectedToInternet)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected network error")
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_performRequest_serverError() {
        let expectation = self.expectation(description: "Server error")

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil)
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected server error")
            case .failure(let error):
                if case .serverError(let statusCode) = error {
                    XCTAssertEqual(statusCode, 500)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected server error")
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_performRequest_decodingError() {
        let expectation = self.expectation(description: "Decoding error")
        let mockData = """
            {
                "coord": {"lon": -118.4912, "lat": 34.0194},
                "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
                "base": "stations",
                "main": {"temp": "invalid_temp", "feels_like": 298.15, "temp_min": 296.15, "temp_max": 300.15, "pressure": 1013, "humidity": 40},
                "visibility": 10000,
                "wind": {"speed": 3.6, "deg": 250},
                "clouds": {"all": 1},
                "dt": 1605182400,
                "timezone": -28800,
                "id": 5392171,
                "name": "Santa Monica",
                "cod": 200
            }
            """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData)
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected decoding error")
            case .failure(let error):
                if case .decodingError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected decoding error")
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_performRequest_emptyData() {
        let expectation = self.expectation(description: "Empty data")

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected empty data error")
            case .failure(let error):
                if case .emptyData = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected empty data error")
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_performRequest_invalidResponse() {
        let expectation = self.expectation(description: "Invalid response")

        MockURLProtocol.requestHandler = { request in
            let response = URLResponse(url: request.url!,
                                       mimeType: nil,
                                       expectedContentLength: 0,
                                       textEncodingName: nil)
            return (response, Data())
        }

        apiRequester.performRequest(with: WeatherRequest.fetchWeather(latitude: 34.0194, longitude: -118.4912)) { (result: Result<WeatherNetworkResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected invalid response error")
            case .failure(let error):
                if case .invalidResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected invalid response error")
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
