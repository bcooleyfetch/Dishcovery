//
//  ImageLoaderViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI
import Combine

@MainActor
class ImageLoader: ObservableObject {
  @Published var image: UIImage?  // ✅ Triggers UI updates
  private let recipe: Recipe
  private let cache = ImageCache()
  private var hasLoadedLargeImage = false
  private var cancellables = Set<AnyCancellable>()

  init(recipe: Recipe) {
    self.recipe = recipe
    Task {
      await loadImage()
    }
  }

  /// ✅ Load the best available image (large if cached, otherwise small).
  private func loadImage() async {
    if let largeURL = recipe.photoURLLarge, await cache.exists(url: largeURL) {
      self.image = await cache.load(url: largeURL)
      hasLoadedLargeImage = true
      return
    }

    if let smallURL = recipe.photoURLSmall {
      self.image = await cache.load(url: smallURL)
    }
  }

  /// ✅ Load large image, purge small image, and notify UI.
  func loadLargeImage() async {
    if hasLoadedLargeImage { return }

    if let largeURL = recipe.photoURLLarge {
      if let largeImage = await cache.load(url: largeURL) {
        DispatchQueue.main.async {
          self.image = largeImage  // ✅ Triggers UI update in RecipeCard
        }
        hasLoadedLargeImage = true

        if let smallURL = recipe.photoURLSmall {
          await cache.remove(url: smallURL)
        }
      }
    }
  }
}
