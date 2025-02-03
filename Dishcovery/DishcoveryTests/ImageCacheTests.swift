//
//  ImageCacheTests.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/2/25.
//

import XCTest
@testable import Dishcovery

/// Unit tests for `ImageCache`, verifying caching behavior for images in memory and disk.
final class ImageCacheTests: XCTestCase {
  
  var imageCache: MockImageCache!
  var testURL: URL!
  var testImage: UIImage!
  
  override func setUp() async throws {
    try await super.setUp()
    imageCache = MockImageCache()
    testURL = URL(string: "https://example.com/image.jpg")!
    testImage = UIImage(systemName: "photo")!
  }
  
  override func tearDown() async throws {
    testURL = nil
    testImage = nil
    imageCache = nil
    try await super.tearDown()
  }
  
  /// Tests whether an image can be successfully stored and retrieved from memory.
  func testLoadImage_CachesInMemory() async throws {
    await imageCache.setImage(testImage, for: testURL)
    
    let cachedImage = await imageCache.load(url: testURL)
    
    XCTAssertNotNil(cachedImage, "Cached image should be retrievable from memory.")
  }
  
  /// Tests whether `exists(url:)` correctly detects an image in memory.
  func testImageExists_InMemory() async throws {
    await imageCache.setImage(testImage, for: testURL)
    
    let exists = await imageCache.exists(url: testURL)
    
    XCTAssertTrue(exists, "Image should be detected in memory cache.")
  }
  
  /// Tests that `remove(url:)` successfully deletes an image from memory.
  func testRemoveImage_ClearsCache() async throws {
    await imageCache.setImage(testImage, for: testURL)
    
    await imageCache.remove(url: testURL)
    
    let existsInMemory = await imageCache.exists(url: testURL)
    
    XCTAssertFalse(existsInMemory, "Image should be removed from memory cache.")
  }
}
