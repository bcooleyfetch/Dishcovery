//
//  MockAPIService.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/3/25.
//

import Foundation
@testable import Dishcovery

/// A mock API service that conforms to `APIServiceProtocol`, allowing for controlled testing.
/// This mock service can return predefined recipes or simulate errors.
final class MockAPIService: APIServiceProtocol {
  var mockRecipes: [Recipe] = []
  var shouldThrowError: APIError?

  func fetchRecipies() async throws -> [Recipe] {
    if let error = shouldThrowError {
      throw error
    }
    return mockRecipes
  }
}
