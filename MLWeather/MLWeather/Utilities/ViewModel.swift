//
//  ViewModel.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// A protocol defining a ViewModel with associated State and Action types.
protocol ViewModel {
    associatedtype State
    associatedtype Action
    
    /// A closure that gets called whenever the state changes.
    var stateChanged: ((State) -> Void)? { get set }
    
    /// Sends an action to the ViewModel.
    /// - Parameter action: The action to be sent.
    func send(action: Action)
}
