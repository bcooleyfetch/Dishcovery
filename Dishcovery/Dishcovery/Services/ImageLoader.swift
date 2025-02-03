//
//  ImageLoaderViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// Handles image loading with caching, prioritizing larger images when available.
@MainActor
class ImageLoader: ImageLoaderProtocol {
  private let recipe: Recipe
  private let cache: ImageCacheProtocol
  private var hasLoadedLargeImage = false

  /// Initializes an image loader for a specific recipe.
  /// - Parameters:
  ///   - recipe: The recipe whose images will be loaded.
  ///   - cache: The image cache used for storing and retrieving images.
  init(recipe: Recipe, cache: ImageCacheProtocol = ImageCache()) {
    self.recipe = recipe
    self.cache = cache
  }

  func loadImage() async -> UIImage? {
    // Check if a large image is already cached and use it.
    if let largeURL = recipe.photoURLLarge, await cache.exists(url: largeURL) {
      hasLoadedLargeImage = true
      return await cache.load(url: largeURL)
    }

    // Otherwise, load the small image if available.
    if let smallURL = recipe.photoURLSmall {
      return await cache.load(url: smallURL)
    }

    return nil
  }

  func loadLargeImage() async -> UIImage? {
    // Avoid reloading the large image if it's already loaded.
    if hasLoadedLargeImage { return nil }

    if let largeURL = recipe.photoURLLarge, let largeImage = await cache.load(url: largeURL) {
      hasLoadedLargeImage = true

      // Remove the small image from cache since the large one is now available.
      if let smallURL = recipe.photoURLSmall {
        await cache.remove(url: smallURL)
      }

      return largeImage
    }

    return nil
  }
}
