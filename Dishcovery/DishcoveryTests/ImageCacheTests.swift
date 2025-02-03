//
//  ImageCacheTests.swift
//  DishcoveryTests
//
//  Created by Brad Cooley on 2/2/25.
//

import XCTest
import SwiftUI
@testable import Dishcovery

/// Unit tests for `ImageCache`, verifying caching behavior for images in memory and disk.
final class ImageCacheTests: XCTestCase {

  var imageCache: ImageCache!
  var testURL: URL!
  var testImage: UIImage!

  override func setUp() async throws {
    try await super.setUp()
    imageCache = ImageCache()
    testURL = URL(string: "https://example.com/image.jpg")!
    testImage = UIImage(systemName: "photo")!
  }

  override func tearDown() async throws {
    testURL = nil
    testImage = nil
    imageCache = nil
    try await super.tearDown()
  }

  /// Tests whether an image can be successfully loaded into memory and retrieved.
  func testLoadImage_CachesInMemory() async throws {
    let imageData = testImage.pngData()!
    
    // Simulate saving the image in cache
    await imageCache.memoryCache[testURL.absoluteString.sha256] = UIImage(data: imageData)

    let cachedImage = await imageCache.load(url: testURL)

    XCTAssertNotNil(cachedImage, "Cached image should be retrievable from memory.")
  }

  /// Tests whether an image is correctly stored on disk and retrieved later.
  func testLoadImage_CachesOnDisk() async throws {
    let imageData = testImage.pngData()!
    let cacheKey = testURL.absoluteString.sha256
    let filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      .first!.appendingPathComponent(cacheKey)

    try imageData.write(to: filePath)

    let cachedImage = await imageCache.load(url: testURL)

    XCTAssertNotNil(cachedImage, "Cached image should be retrievable from disk.")
  }

  /// Tests whether `exists(url:)` correctly detects an image in memory.
  func testImageExists_InMemory() async throws {
    let cacheKey = testURL.absoluteString.sha256
    await imageCache.memoryCache[cacheKey] = testImage

    let exists = await imageCache.exists(url: testURL)

    XCTAssertTrue(exists, "Image should be detected in memory cache.")
  }

  /// Tests whether `exists(url:)` correctly detects an image on disk.
  func testImageExists_OnDisk() async throws {
    let imageData = testImage.pngData()!
    let cacheKey = testURL.absoluteString.sha256
    let filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      .first!.appendingPathComponent(cacheKey)

    try imageData.write(to: filePath)

    let exists = await imageCache.exists(url: testURL)

    XCTAssertTrue(exists, "Image should be detected in disk cache.")
  }

  /// Tests that `remove(url:)` successfully deletes an image from both memory and disk caches.
  func testRemoveImage_ClearsCache() async throws {
    let imageData = testImage.pngData()!
    let cacheKey = testURL.absoluteString.sha256
    let filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      .first!.appendingPathComponent(cacheKey)

    // Save image in both memory and disk caches
    await imageCache.memoryCache[cacheKey] = testImage
    try imageData.write(to: filePath)

    // Remove the image
    await imageCache.remove(url: testURL)

    let existsInMemory = await imageCache.memoryCache[cacheKey] != nil
    let existsOnDisk = FileManager.default.fileExists(atPath: filePath.path)

    XCTAssertFalse(existsInMemory, "Image should be removed from memory cache.")
    XCTAssertFalse(existsOnDisk, "Image should be removed from disk cache.")
  }
}