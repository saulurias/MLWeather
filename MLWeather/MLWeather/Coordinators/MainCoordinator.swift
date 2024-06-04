//
//  MainCoordinator.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherViewController = WeatherDetailViewController()
        weatherViewController.coordinator = self
        navigationController.pushViewController(weatherViewController, animated: true)
    }
}
