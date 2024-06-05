//
//  WeatherRequestTests.swift
//  MLWeatherTests
//
//  Created by Saul on 04/06/24.
//

import XCTest

import XCTest
@testable import MLWeather

class WeatherRequestTests: XCTestCase {

    func test_fetchWeatherRequest() {
        let latitude = 34.0194704
        let longitude = -118.491227
        let weatherRequest = WeatherRequest.fetchWeather(latitude: latitude, longitude: longitude)
        
        let urlRequest = weatherRequest.makeUrlRequest()
        
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        
        if let url = urlRequest?.url {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            XCTAssertEqual(components?.path, "/data/2.5/weather")
            
            let queryItems = components?.queryItems
            XCTAssertNotNil(queryItems)
            
            let queryDict = Dictionary(uniqueKeysWithValues: queryItems!.map { ($0.name, $0.value) })
            
            XCTAssertEqual(queryDict["lat"], "\(latitude)")
            XCTAssertEqual(queryDict["lon"], "\(longitude)")
            XCTAssertEqual(queryDict["appid"], APIEnvironment.current.appId)
        } else {
            XCTFail("URL is nil")
        }
    }
}
