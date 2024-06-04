//
//  APIErrorMessage.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// A structure representing an error message received from an API.
struct APIErrorMessage: Decodable {
    /// The error code
    let code: Int
    /// The error message string.
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
    }
}
