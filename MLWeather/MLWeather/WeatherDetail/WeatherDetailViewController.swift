//
//  WeatherDetailViewController.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import CoreLocation
import Kingfisher
import UIKit

final class WeatherDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var mainAndLowTemperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var coordinator: MainCoordinator?
    private let viewModel: WeatherDetailViewModel
    private let locationManager = LocationManager()
    private let refreshControl = UIRefreshControl()
    private let errorView = ErrorView()
    
    // MARK: - Initialization
    init(viewModel: WeatherDetailViewModel = WeatherDetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupRefreshControl()
        setupIconImageView()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    // MARK: - Setup Methods
    
    private func setupIconImageView() {
        weatherIconImageView.layer.cornerRadius = 10
        weatherIconImageView.clipsToBounds = true
        weatherIconImageView.layer.shadowColor = UIColor.black.cgColor
        weatherIconImageView.layer.shadowOpacity = 0.3
        weatherIconImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        weatherIconImageView.layer.shadowRadius = 4
    }
    
    private func setupBindings() {
        viewModel.stateChanged = { [weak self] state in
            self?.handleStateChange(state)
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    @objc private func refreshWeatherData() {
        locationManager.requestLocation()
    }
    
    // MARK: - State Handling
    private func handleStateChange(_ state: WeatherDetailViewModel.State) {
        DispatchQueue.main.async {
            self.updateUI(for: state)
        }
    }
    
    // MARK: - UI Update
    private func updateUI(for state: WeatherDetailViewModel.State) {
        switch state {
        case .idle, .loading:
            showLoadingState()
        case .loaded(let weatherDetailModel):
            showLoadedState(with: weatherDetailModel)
        case .error(let errorMessage):
            showErrorState(with: errorMessage)
        }
    }
    
    private func showLoadingState() {
        activityIndicator.startAnimating()
        weatherIconImageView.isHidden = true
        errorView.hide()
    }
    
    private func showLoadedState(with weatherDetailModel: WeatherDetailModel) {
        activityIndicator.stopAnimating()
        weatherIconImageView.isHidden = false
        errorView.hide()
        refreshControl.endRefreshing()
        updateWeatherDetails(with: weatherDetailModel)
    }
    
    private func showErrorState(with errorMessage: String) {
        activityIndicator.stopAnimating()
        errorView.configure(with: errorMessage) { [weak self] in
            self?.refreshWeatherData()
        }
        errorView.show(in: view)
        refreshControl.endRefreshing()
    }
    
    private func updateWeatherDetails(with weatherDetailModel: WeatherDetailModel) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.cityNameLabel.text = weatherDetailModel.cityName
            self?.weatherDescriptionLabel.text = weatherDetailModel.weatherDescription
            self?.temperatureLabel.text = weatherDetailModel.temperature
            self?.mainAndLowTemperatureLabel.text = weatherDetailModel.highLowTemperature
            self?.windLabel.text = weatherDetailModel.wind
        }
        
        if let iconURL = weatherDetailModel.iconURL {
            loadImage(from: iconURL)
        }
    }
    
    // MARK: - Image Loading
    private func loadImage(from url: URL) {
        weatherIconImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}

// MARK: - LocationManagerDelegate
extension WeatherDetailViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        viewModel.send(action: .loadWeather(latitude: latitude, longitude: longitude))
    }
    
    func didFailWithError(error: Error) {
        viewModel.send(action: .loadingFailed(error.localizedDescription))
    }
}
