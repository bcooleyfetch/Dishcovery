//
//  APIService.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation

final class APIService: APIServiceProtocol {
  
  private let baseURL: String
  
  init(baseURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
    self.baseURL = baseURL
  }
  
  func fetchRecipies() async throws -> [Recipe] {
    guard let url = URL(string: baseURL) else {
      throw APIError.invalidURL
    }
    
    let request = URLRequest(url: url)
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      
      // Check response status code
      // Note: Ideally, our API returns different status codes for empty data (204), and we could
      //       handle that here. However, since it doesn't, I'm just going to cover all "successful"
      //       status codes
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        throw APIError.invalidResponse
      }
      
      // Decode response into an array of Recipe objects
      let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
      return decodedResponse.recipes
    } catch let decodingError as DecodingError {
      throw APIError.decodingError("Failed to decode API response: \(decodingError.localizedDescription)")
    } catch {
      throw APIError.invalidResponse
    }
  }
}
