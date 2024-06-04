//
//  WeatherDetailViewController.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit
import CoreLocation

final class WeatherDetailViewController: UIViewController, LocationManagerDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var mainAndLowTemperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    // MARK: - Properties
    var coordinator: MainCoordinator?
    private let viewModel: WeatherDetailViewModel
    private let locationManager = LocationManager()
    
    init(viewModel: WeatherDetailViewModel = WeatherDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationManager.delegate = self
        setupBindings()
        locationManager.requestLocation()
    }
    
    private func setupBindings() {
        viewModel.stateChanged = { [weak self] state in
            self?.handleStateChange(state)
        }
    }
    
    private func handleStateChange(_ state: WeatherDetailViewModel.State) {
        switch state {
        case .idle:
            break
        case .loading:
            print("Loading weather data...")
        case .loaded(let weatherDetailModel):
            self.updateUI(with: weatherDetailModel)
        case .error(let errorMessage):
            self.showError(errorMessage)
        }
    }
    
    private func updateUI(with weatherDetailModel: WeatherDetailModel) {
        cityNameLabel.text = weatherDetailModel.cityName
        weatherDescriptionLabel.text = weatherDetailModel.weatherDescription
        temperatureLabel.text = weatherDetailModel.temperature
        mainAndLowTemperatureLabel.text = weatherDetailModel.highLowTemperature
        windLabel.text = weatherDetailModel.wind
        
        if let iconURL = weatherDetailModel.iconURL {
            // TODO: - Use Kingfisher
        }
    }
    
    private func showError(_ errorMessage: String) {
        print("Error: \(errorMessage)")
    }
    
    // MARK: - LocationManagerDelegate
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        viewModel.send(action: .loadWeather(latitude: latitude, longitude: longitude))
    }
    
    func didFailWithError(error: Error) {
        viewModel.send(action: .loadingFailed(error.localizedDescription))
    }
}
