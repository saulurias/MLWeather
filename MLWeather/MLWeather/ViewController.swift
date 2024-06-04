//
//  ViewController.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiRequester = APIRequester()
    
    @IBAction func buttonPressed(_ sender: Any) {
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        let weatherRequest = WeatherRequest.fetchWeather(latitude: 34.0194704, longitude: -118.4912273)
        
        apiRequester.performRequest(with: weatherRequest) { (result: Result<WeatherResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self.handleSuccess(weatherResponse)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleSuccess(_ weatherResponse: WeatherResponse) {
        print("Weather data: \(weatherResponse)")
        // Update your UI with the weather data here
    }
    
    private func handleError(_ error: NetworkError) {
        print("Error fetching weather data: \(error)")
        // Handle the error here, e.g., show an alert to the user
    }
    
    
    enum WeatherRequest: Request {
        var method: HTTPMethod {
            .get
        }
        
        var path: String {
            return "weather"
        }
        
        var body: (any Encodable)? {
            return nil
        }
        
        var parameters: [URLQueryItem] {
            return [
                URLQueryItem(name: "lat", value: "34.0194704"),
                URLQueryItem(name: "lon", value: "-118.4912273"),
                URLQueryItem(name: "appid", value: "d4277b87ee5c71a468ec0c3dc311a724"),
            ]
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
        
        case fetchWeather(latitude: Double, longitude: Double)
    }
    
}


struct WeatherResponse: Codable {
    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
