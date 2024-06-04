//
//  WeatherRequest.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

enum WeatherRequest: Request {
    case fetchWeather(latitude: Double, longitude: Double)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "weather"
    }

    var body: (any Encodable)? {
        return nil
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .fetchWeather(let latitude, let longitude):
            return [
                URLQueryItem(name: "lat", value: "\(latitude)"),
                URLQueryItem(name: "lon", value: "\(longitude)"),
                URLQueryItem(name: "appid", value: "d4277b87ee5c71a468ec0c3dc311a724")
            ]
        }
    }

    func makeUrlRequest() -> URLRequest? {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(path)")
        components?.queryItems = parameters
        
        guard let url = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        return request
    }
}
