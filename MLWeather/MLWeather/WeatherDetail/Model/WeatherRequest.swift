//
//  WeatherRequest.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// An enumeration that defines requests related to weather data.
enum WeatherRequest: Request {
    /// Request to fetch weather data based on latitude and longitude.
    case fetchWeather(latitude: Double, longitude: Double)

    /// The HTTP method to be used for the request.
    var method: HTTPMethod {
        .get
    }

    /// The path of the API endpoint.
    var path: String {
        "data/2.5/weather"
    }

    /// The body of the request, which is nil for this request type.
    var body: (any Encodable)? {
        nil
    }

    /// The URL query parameters for the request.
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

    /// Creates a `URLRequest` from the defined parameters.
    /// - Returns: A configured `URLRequest` or nil if the URL is invalid.
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
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        return request
    }
}
