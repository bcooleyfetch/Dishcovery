//
//  ImageLoaderViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// Handles image loading with caching, prioritizing larger images when available.
@MainActor
class ImageLoader {
  /// The recipe associated with this image loader.
  private let recipe: Recipe
  private let cache = ImageCache()
  private var hasLoadedLargeImage = false

  /// Initializes an image loader for a specific recipe.
  /// - Parameter recipe: The recipe whose images will be loaded.
  init(recipe: Recipe) {
    self.recipe = recipe
  }

  /// Loads the best available image.
  /// - Returns: The cached or downloaded image, prioritizing the large image if available.
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

  /// Loads the large image and purges the small image if necessary.
  /// - Returns: The large image if successfully loaded, otherwise `nil`.
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
