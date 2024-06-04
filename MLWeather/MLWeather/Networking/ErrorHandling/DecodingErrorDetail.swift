//
//  DecodingErrorDetail.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// An enumeration representing different details of decoding errors.
enum DecodingErrorDetail: Error, Equatable {
    /// The JSON is invalid.
    case invalidJSON
    /// The data is corrupted with a specific message.
    case dataCorrupted(String)
    /// A required key was not found with a specific key and context.
    case keyNotFound(String, String)
    /// A type mismatch occurred with a specific key and context.
    case typeMismatch(String, String)
    /// A required value was not found with a specific key and context.
    case valueNotFound(String, String)
    /// An unknown error occurred with a specific message.
    case unknown(String)
}
