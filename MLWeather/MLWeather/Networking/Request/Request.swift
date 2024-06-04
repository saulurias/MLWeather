//
//  Request.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// Protocol defining the requirements for a network request.
protocol Request {
    /// The HTTP method for the request (e.g., GET, POST).
    var method: HTTPMethod { get }
    
    /// The path for the request, relative to the base URL.
    var path: String { get }
    
    /// The body of the request, if any, conforming to `Encodable`.
    var body: Encodable? { get }
    
    var parameters: [URLQueryItem] { get }
    
    /// Creates a `URLRequest` from the properties of the conforming type.
    ///
    /// - Returns: A configured `URLRequest` or nil if the request could not be created.
    func makeUrlRequest() -> URLRequest?
}
