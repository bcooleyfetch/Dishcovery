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
    recipe: MockRecipe.sample
  ) { print("Close") }
}
