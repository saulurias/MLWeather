# MLWeather 🌦



https://github.com/saulurias/MLWeather/assets/11281932/3d5511ed-0ee3-4c3b-a32f-75b14552fd0d



## Overview

MLWeather is an iOS application that displays current weather information for the device location using the OpenWeatherMap API. The app is built using UIKit and follows a modular MVVM-C (Model-View-ViewModel-Coordinator) architecture to ensure maintainability and scalability. The project includes a network layer for API requests and uses CocoaPods as the dependency manager with Kingfisher for image loading.

## Features

- Display current weather details including:
  - City name
  - Weather icon
  - Current temperature
  - Weather description
  - Low and high temperatures
  - Wind speed and direction
- Works on light and dark mode
- Works on Portrait and Landscape
- Works on iPhone and iPad (Also on Macbook as iPad App) 

## Requirements

- iOS 17.5+
- Xcode 15.4+
- Swift 5.0+

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/saulurias/MLWeather.git
    ```
2. Navigate to the project directory:
    ```sh
    cd MLWeather
    ```
3. Install the dependencies:
    ```sh
    pod install
    ```
4. Open the project in Xcode:
    ```sh
    open MLWeather.xcworkspace
    ```

## Usage

1. Open the project in Xcode.
2. **Add your OpenWeatherMap API key** to `APIEnvironment`:
    ```swift
    var appId: String {
        let apiKey: String
        switch self {
        case .production:
            apiKey = "YOUR_API_KEY" // Replace with your actual API key
        case .development:
            apiKey = "YOUR_API_KEY" // Replace with your actual API key
        }
        
        return apiKey
    }
    ```
3. Build and run the app on a simulator or a physical device.

## Architecture

The project is structured using a modular MVVM-C (Model-View-ViewModel-Coordinator) architecture.

- **Model**: Defines the data structures.
- **View**: Manages UI components.
- **ViewModel**: Handles the business logic and state management.
- **Coordinator**: Manages the navigation flow and coordination between view controllers.

## Network Layer

The network layer handles all API requests and responses, ensuring a clean separation of concerns and easier maintenance.

## API

The app uses the OpenWeatherMap API to fetch weather data.

Example API URL:
```
https://api.openweathermap.org/data/2.5/weather?lat=34.0194704&lon=-118.491227&appid=YOUR_API_KEY
```

## Dependencies

The project uses CocoaPods as the dependency manager and includes the following dependencies:
- [Kingfisher](https://github.com/onevcat/Kingfisher): For downloading and caching images.

To install the dependencies, run:
```sh
pod install
