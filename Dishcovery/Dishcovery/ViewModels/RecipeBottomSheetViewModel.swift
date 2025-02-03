//
//  RecipeBottomSheetViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// ViewModel for `RecipeBottomSheet`, handling image loading logic.
@MainActor
class RecipeBottomSheetViewModel: ObservableObject {
  @Published var image: UIImage?
  private let imageLoader: ImageLoader

  init(recipe: Recipe) {
    self.imageLoader = ImageLoader(recipe: recipe)
    Task { await loadImage() }
  }

  /// Loads the best available image asynchronously.
  private func loadImage() async {
    if let largeImage = await imageLoader.loadLargeImage() {
      self.image = largeImage
    } else {
      self.image = await imageLoader.loadImage()
    }
  }
}
