//
//  Coordinator.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
