//
//  APIServiceProtocol.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

/// Protocol defining the API service for fetching recipes.
/// This allows for dependency injection and makes it easier to mock API responses for testing.
protocol APIServiceProtocol {
  /// Fetches an array of `Recipe` objects asynchronously.
  /// - Returns: An array of `Recipe` objects retrieved from the API.
  /// - Throws:
  ///  - `APIError` if there is an error getting data back from the API, like malformed data or an invalid URL
  func fetchRecipies() async throws -> [Recipe]
}
