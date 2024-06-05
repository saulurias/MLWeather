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
        .get
    }

    var path: String {
        "data/2.5/weather"
    }

    var body: (any Encodable)? {
        nil
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .fetchWeather(let latitude, let longitude):
            return [
                URLQueryItem(name: "lat", value: "\(latitude)"),
                URLQueryItem(name: "lon", value: "\(longitude)"),
                URLQueryItem(name: "appid", value: APIEnvironment.current.appId)
            ]
        }
    }

    func makeUrlRequest() -> URLRequest? {
        var components = URLComponents(
            string: "\(APIEnvironment.current.baseURL)\(path)"
        )
        components?.queryItems = parameters
        
        guard let url = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(ContentType.json.rawValue,
                         forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        return request
    }
}
