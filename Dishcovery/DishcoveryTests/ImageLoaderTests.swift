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
  
  var imageLoader: ImageLoaderProtocol!
  var mockCache: MockImageCache!
  var testRecipe: Recipe!
  var testImage: UIImage!
  
  override func setUp() async throws {
    try await super.setUp()
    mockCache = MockImageCache()
    testRecipe = MockRecipe.sample
    testImage = UIImage(systemName: "photo")!
    
    imageLoader = await ImageLoader(recipe: testRecipe, cache: mockCache)
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
    guard let largeURL = testRecipe.photoURLLarge else {
      XCTFail("Large image URL should not be nil")
      return
    }
    
    let imageData = testImage.pngData()!
    await mockCache.setImage(UIImage(data: imageData)!, for: largeURL)
    
    let loadedImage = await imageLoader.loadImage()
    
    XCTAssertNotNil(loadedImage, "Large image should be loaded if cached.")
  }
  
  /// Tests that `loadImage()` falls back to the small image if the large one is missing.
  func testLoadImage_FallsBackToSmallImage() async throws {
    guard let smallURL = testRecipe.photoURLSmall else {
      XCTFail("Small image URL should not be nil")
      return
    }
    
    let imageData = testImage.pngData()!
    await mockCache.setImage(UIImage(data: imageData)!, for: smallURL)
    
    let loadedImage = await imageLoader.loadImage()
    
    XCTAssertNotNil(loadedImage, "Small image should be loaded if large image is not available.")
  }
  
  /// Tests that `loadLargeImage()` loads and caches the large image, then purges the small one.
  func testLoadLargeImage_DeletesSmallImage() async throws {
    guard let largeURL = testRecipe.photoURLLarge, let smallURL = testRecipe.photoURLSmall else {
      XCTFail("Image URLs should not be nil")
      return
    }
    
    let imageData = testImage.pngData()!
    await mockCache.setImage(UIImage(data: imageData)!, for: smallURL)
    await mockCache.setImage(UIImage(data: imageData)!, for: largeURL)
    
    let loadedLargeImage = await imageLoader.loadLargeImage()
    
    XCTAssertNotNil(loadedLargeImage, "Large image should be loaded if available.")
    
    // Small image should be removed after loading large image
    let smallImageExists = await mockCache.exists(url: smallURL)
    XCTAssertFalse(smallImageExists, "Small image should be purged after loading large image.")
  }
  
  /// Tests that `loadLargeImage()` does not reload if already loaded.
  func testLoadLargeImage_DoesNotReloadIfAlreadyLoaded() async throws {
    guard let largeURL = testRecipe.photoURLLarge else {
      XCTFail("Large image URL should not be nil")
      return
    }
    
    let imageData = testImage.pngData()!
    await mockCache.setImage(UIImage(data: imageData)!, for: largeURL)
    
    // Load large image the first time
    _ = await imageLoader.loadLargeImage()
    // Try to load again (should return nil since it's already loaded)
    let secondLoad = await imageLoader.loadLargeImage()
    
    XCTAssertNil(secondLoad, "loadLargeImage should return nil if already loaded.")
  }
}
