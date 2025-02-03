//
//  MockAPIService.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//


//
//  APIServiceTests.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/2/25.
//

import XCTest
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

/// Unit tests for `APIService`, using a mock API service to simulate different API responses.
final class APIServiceTests: XCTestCase {
  
  var mockService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    mockService = MockAPIService()
  }
  
  override func tearDown() {
    mockService = nil
    super.tearDown()
  }

  /// Tests if `fetchRecipies()` successfully returns mock recipe data.
  func testFetchRecipes_Success() async throws {
    let expectedRecipe = Recipe(
      id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
      cuisine: "Italian",
      name: "Pasta Carbonara",
      photoURLSmall: URL(string: "https://example.com/small.jpg"),
      photoURLLarge: URL(string: "https://example.com/large.jpg"),
      sourceURL: URL(string: "https://example.com/recipe"),
      youtubeURL: URL(string: "https://youtube.com/watch?v=example")
    )

    mockService.mockRecipes = [expectedRecipe]

    let recipes = try await mockService.fetchRecipies()

    XCTAssertEqual(recipes.count, 1, "The fetched recipes count should be 1.")
    XCTAssertEqual(recipes.first?.name, "Pasta Carbonara", "The recipe name should match the expected value.")
  }

  /// Tests if `fetchRecipies()` throws an error for an invalid URL.
  func testFetchRecipes_InvalidURL() async {
    mockService.shouldThrowError = .invalidURL

    do {
      _ = try await mockService.fetchRecipies()
      XCTFail("Expected APIError.invalidURL, but no error was thrown.")
    } catch let error as APIError {
      XCTAssertEqual(error, .invalidURL, "The error should be APIError.invalidURL.")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  /// Tests if `fetchRecipies()` throws an error when the API response is invalid.
  func testFetchRecipes_InvalidResponse() async {
    mockService.shouldThrowError = .invalidResponse

    do {
      _ = try await mockService.fetchRecipies()
      XCTFail("Expected APIError.invalidResponse, but no error was thrown.")
    } catch let error as APIError {
      XCTAssertEqual(error, .invalidResponse, "The error should be APIError.invalidResponse.")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  /// Tests if `fetchRecipies()` throws an error when the JSON response cannot be decoded.
  func testFetchRecipes_DecodingError() async {
    mockService.shouldThrowError = .decodingError("Failed to decode")

    do {
      _ = try await mockService.fetchRecipies()
      XCTFail("Expected APIError.decodingError, but no error was thrown.")
    } catch let error as APIError {
      XCTAssertTrue("\(error)".contains("Failed to decode"), "The error should indicate a decoding failure.")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}