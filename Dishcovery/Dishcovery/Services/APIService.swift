//
//  APIService.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation

final class APIService: APIServiceProtocol {

  private let baseURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

  func fetchRecipies() async -> [Recipe] {
    let url = URL(string: baseURL)!

    let request = URLRequest(url: url)

    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        print("Error with HTTP response: \(String(describing: response))")
        return []
      }

      let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
      return decodedResponse.recipes

    } catch {
      print("Error getting data from API: \(error)")
    }
    return []
  }
}
