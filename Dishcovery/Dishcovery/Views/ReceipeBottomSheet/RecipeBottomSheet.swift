//
//  RecipeBottomSheet.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// A bottom sheet displaying detailed information about a recipe.
struct RecipeBottomSheet: View {
  let recipe: Recipe
  let onClose: () -> Void

  @StateObject private var viewModel: RecipeBottomSheetViewModel

  init(recipe: Recipe, onClose: @escaping () -> Void) {
    self.recipe = recipe
    self.onClose = onClose
    _viewModel = StateObject(wrappedValue: RecipeBottomSheetViewModel(recipe: recipe))
  }

  var body: some View {
    VStack(spacing: 16) {
      RecipeBottomSheetHeader(recipe: recipe, image: viewModel.image, onClose: onClose)
      RecipeBottomSheetActions(recipe: recipe)
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  RecipeBottomSheet(
    recipe: Recipe(
      cuisine: "British",
      name: "Fish & Chips",
      photoURLLarge: URL(string: "https://static1.squarespace.com/static/62b0db0c1be03b40824ca350/62b7504d182c361584382f1c/62b8b75d77148a5bbe7e7765/1705787522089/IMG_9320_sq.jpg?format=3500w")!,
      sourceURL: URL(string: "https://www.google.com/"),
      youtubeURL: URL(string: "https://www.youtube.com/")
    )
  ) { print("Close") }
}
