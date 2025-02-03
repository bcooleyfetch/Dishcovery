//
//  ImageLoaderTests.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/3/25.
//

import XCTest
import SwiftUI
@testable import Dishcovery

/// Unit tests for `ImageLoader`, ensuring correct caching behavior.
final class ImageLoaderTests: XCTestCase {

  var imageLoader: ImageLoader!
  var mockCache: MockImageCache!
  var testRecipe: Recipe!
  var testImage: UIImage!

  override func setUp() async throws {
    try await super.setUp()
    mockCache = MockImageCache()
    testRecipe = Recipe(
      id: UUID(),
      cuisine: "British",
      name: "Fish & Chips",
      photoURLSmall: URL(string: "https://example.com/small.jpg"),
      photoURLLarge: URL(string: "https://example.com/large.jpg")
    )
    testImage = UIImage(systemName: "photo")!
    imageLoader = ImageLoader(recipe: testRecipe, cache: mockCache)
  }

  override func tearDown() async throws {
    imageLoader = nil
    mockCache = nil
    testRecipe = nil
    testImage = nil
    try await super.tearDown()
  }

  /// Tests that `loadImage()` prioritizes the large image if it exists in the cache.
  func testLoadImage_PrioritizesLargeImage() async throws {
    let largeURL = testRecipe.photoURLLarge!
    let smallURL = testRecipe.photoURLSmall!
    let imageData = testImage.pngData()!

    // Simulate cached large image
    mockCache.mockStorage[largeURL.absoluteString] = UIImage(data: imageData)

    let loadedImage = await imageLoader.loadImage()

    XCTAssertNotNil(loadedImage, "Large image should be loaded if cached.")
  }

  /// Tests that `loadImage()` falls back to the small image if the large one is missing.
  func testLoadImage_FallsBackToSmallImage() async throws {
    let smallURL = testRecipe.photoURLSmall!
    let imageData = testImage.pngData()!

    // Simulate cached small image
    mockCache.mockStorage[smallURL.absoluteString] = UIImage(data: imageData)

    let loadedImage = await imageLoader.loadImage()

    XCTAssertNotNil(loadedImage, "Small image should be loaded if large image is not available.")
  }

  /// Tests that `loadLargeImage()` loads and caches the large image, then purges the small one.
  func testLoadLargeImage_DeletesSmallImage() async throws {
    let largeURL = testRecipe.photoURLLarge!
    let smallURL = testRecipe.photoURLSmall!
    let imageData = testImage.pngData()!

    // Simulate cached small image
    mockCache.mockStorage[smallURL.absoluteString] = UIImage(data: imageData)
    // Simulate loading large image
    mockCache.mockStorage[largeURL.absoluteString] = UIImage(data: imageData)

    let loadedLargeImage = await imageLoader.loadLargeImage()

    XCTAssertNotNil(loadedLargeImage, "Large image should be loaded if available.")
    
    // Small image should be removed after loading large image
    let smallImageExists = await mockCache.exists(url: smallURL)
    XCTAssertFalse(smallImageExists, "Small image should be purged after loading large image.")
  }

  /// Tests that `loadLargeImage()` does not reload if already loaded.
  func testLoadLargeImage_DoesNotReloadIfAlreadyLoaded() async throws {
    let largeURL = testRecipe.photoURLLarge!
    let imageData = testImage.pngData()!

    // Simulate cached large image
    mockCache.mockStorage[largeURL.absoluteString] = UIImage(data: imageData)

    // Load large image the first time
    _ = await imageLoader.loadLargeImage()
    // Try to load again (should return nil since it's already loaded)
    let secondLoad = await imageLoader.loadLargeImage()

    XCTAssertNil(secondLoad, "loadLargeImage should return nil if already loaded.")
  }
}