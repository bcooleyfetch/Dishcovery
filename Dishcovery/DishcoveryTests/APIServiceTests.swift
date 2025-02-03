//
//  APIServiceTests.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/2/25.
//

import XCTest
@testable import Dishcovery

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
    let expectedRecipes = MockRecipe.sampleList

    mockService.mockRecipes = expectedRecipes

    let recipes = try await mockService.fetchRecipies()
    
    XCTAssertEqual(recipes.count, 3, "The fetched recipes count should be 3.")
    XCTAssertEqual(recipes.first?.name, "Coq au Vin", "The recipe name should match the expected value.")
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
