//
//  APIError.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

/// Represents possible errors that can occur when making API requests.
enum APIError: Error, Equatable {
  /// Indicates that the provided URL is invalid or cannot be formed.
  case invalidURL

  /// Indicates that the response from the server was not valid (e.g., wrong status code).
  case invalidResponse

  /// Indicates that there was an error decoding the response data.
  /// - Parameter message: A string describing the decoding error.
  case decodingError(String)
}
