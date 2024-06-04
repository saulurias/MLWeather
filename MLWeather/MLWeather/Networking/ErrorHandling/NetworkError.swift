//
//  NetworkError.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// An enumeration representing different network-related errors.
enum NetworkError: Error {
    /// An error that occurs during data decoding.
    case decodingError(DecodingErrorDetail)
    /// An error indicating that the received data is empty.
    case emptyData
    /// An error with a specific message.
    case errorWithMessage(String)
    /// An error indicating that the response is invalid.
    case invalidResponse
    /// An error indicating that the URL is invalid.
    case invalidURL
    /// An error that occurs during network communication.
    case networkError(Error)
    /// An error indicating a server-side issue with a specific status code.
    case serverError(code: Int)
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .decodingError(let detail):
            return detail.localizedDescription
        case .emptyData:
            return "No data was received from the server."
        case .errorWithMessage(let message):
            return message
        case .invalidResponse:
            return "The server response was invalid."
        case .invalidURL:
            return "Invalid URL for the request"
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(let code):
            return "Server returned an error with code: \(code)"
        }
    }
}

extension DecodingErrorDetail {
    var localizedDescription: String {
        switch self {
        case .invalidJSON:
            return "The JSON data is invalid."
        case .dataCorrupted(let context):
            return "The data is corrupted: \(context)"
        case .keyNotFound(let key, let context):
            return "The key \(key) was not found: \(context)"
        case .typeMismatch(let type, let context):
            return "Type mismatch for type \(type): \(context)"
        case .valueNotFound(let value, let context):
            return "Value not found for value \(value): \(context)"
        case .unknown(let message):
            return message
        }
    }
}
