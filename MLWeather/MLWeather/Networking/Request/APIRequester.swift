//
//  APIRequester.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import Foundation

/// Protocol for performing network requests.
protocol NetworkRequester {
    /// Performs a network request and decodes the response.
    ///
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion handler with the result.
    func performRequest<T: Decodable>(
        with request: Request,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

/// Class that implements `NetworkRequester` to perform network requests.
final class APIRequester: NetworkRequester {
    
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    /// Initializes an `APIRequester` with a session and JSON decoder.
    ///
    /// - Parameters:
    ///   - session: The URL session, default is `.shared`.
    ///   - jsonDecoder: The JSON decoder, default is a new instance.
    init(session: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
    }
    
    /// Performs a network request and decodes the response.
    ///
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion handler with the result.
    func performRequest<T: Decodable>(
        with request: Request,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let urlRequest = request.makeUrlRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        print(urlRequest)
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            self.handleResponse(data: data, response: response, completion: completion)
        }
        dataTask.resume()
    }
    
    private func handleResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponse))
            return
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            guard let responseData = data, !responseData.isEmpty else {
                completion(.failure(.emptyData))
                return
            }
            decodeResponse(data: responseData, completion: completion)
            
        default:
            completion(.failure(.serverError(code: httpResponse.statusCode)))
        }
    }

    private func decodeResponse<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        do {
            let decodedObject = try jsonDecoder.decode(T.self, from: data)
            completion(.success(decodedObject))
        } catch {
            if let errorResponse = try? jsonDecoder.decode(APIErrorMessage.self, from: data) {
                completion(.failure(.errorWithMessage(errorResponse.message)))
            } else if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    completion(.failure(.decodingError(.dataCorrupted(context.debugDescription))))
                case .keyNotFound(let key, let context):
                    completion(.failure(.decodingError(.keyNotFound(key.stringValue, context.debugDescription))))
                case .typeMismatch(let type, let context):
                    completion(.failure(.decodingError(.typeMismatch(String(describing: type), context.debugDescription))))
                case .valueNotFound(let value, let context):
                    completion(.failure(.decodingError(.valueNotFound(String(describing: value), context.debugDescription))))
                @unknown default:
                    completion(.failure(.decodingError(.unknown(decodingError.localizedDescription))))
                }
            } else {
                completion(.failure(.decodingError(.unknown(error.localizedDescription))))
            }
        }
    }
}
