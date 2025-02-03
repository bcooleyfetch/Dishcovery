//
//  RecipeBottomSheetHeader.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// Displays the recipe header with background image, title, and close button.
struct RecipeBottomSheetHeader: View {
  let recipe: Recipe
  let image: UIImage?
  let onClose: () -> Void
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      ZStack(alignment: .leading) {
        backgroundImage
        titleAndCuisine
      }
      closeButton
    }
  }
  
  /// The background image with a dimming overlay.
  @ViewBuilder
  private var backgroundImage: some View {
    if let image = self.image {
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: 140)
        .clipped()
        .overlay(Color.black.opacity(0.65))
    } else {
      Color.gray.opacity(0.3)
        .frame(height: 140)
    }
  }
  
  /// Displays the recipe name and cuisine.
  private var titleAndCuisine: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(recipe.name)
        .font(.title)
        .fontDesign(.rounded)
        .fontWeight(.bold)
        .foregroundStyle(.white)
      BubbleChip(text: recipe.cuisine.displayName)
    }
    .padding()
  }
  
  /// Close button that dismisses the bottom sheet.
  private var closeButton: some View {
    BubbleChip(icon: "xmark") { onClose() }
      .frame(width: 24, height: 24)
      .padding()
  }
}
