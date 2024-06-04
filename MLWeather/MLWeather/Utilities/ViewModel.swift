//
//  ViewModel.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

protocol ViewModel {
    associatedtype State
    associatedtype Action
    
    var stateChanged: ((State) -> Void)? { get set }
    func send(action: Action)
}
