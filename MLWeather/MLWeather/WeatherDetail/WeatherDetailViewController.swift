//
//  WeatherDetailViewController.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    private let viewModel: WeatherDetailViewModel
    
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
        setupBindings()
        viewModel.send(action: .loadWeather)
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
        case .loaded(let weatherResponse):
            self.updateUI(with: weatherResponse)
        case .error(let errorMessage):
            self.showError(errorMessage)
        }
    }
    
    private func updateUI(with weatherResponse: WeatherResponse) {
        print("Weather data: \(weatherResponse)")
    }
    
    private func showError(_ errorMessage: String) {
        print("Error: \(errorMessage)")
    }
}
