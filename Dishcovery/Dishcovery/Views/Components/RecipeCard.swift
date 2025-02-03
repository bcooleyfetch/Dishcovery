//
//  RecipeCard.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import SwiftUI

/// A card representing a recipe, displaying its image, title, and optional links.
struct RecipeCard: View {
  let recipe: Recipe
  private let imageLoader: ImageLoader
  @State private var image: UIImage?

  init(recipe: Recipe) {
    self.recipe = recipe
    self.imageLoader = ImageLoader(recipe: recipe)
  }

  var body: some View {
    ZStack(alignment: .top) {
      if let image = self.image {
        RecipeImage(image: image)
          .overlay(GradientOverlay())
          .overlay(TitleOverlay(text: recipe.name), alignment: .topLeading)
          .overlay(InfoOverlay(recipe: recipe), alignment: .bottomLeading)
      } else {
        ProgressView()
          .task { self.image = await imageLoader.loadImage() }
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

/// Displays the recipe image with proper scaling.
private struct RecipeImage: View {
  let image: UIImage

  var body: some View {
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
  }
}

/// Adds a gradient overlay at the top for better text visibility.
private struct GradientOverlay: View {
  var body: some View {
    VStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(height: 100)
      Spacer()
    }
  }
}

/// Displays the recipe title in a styled format.
private struct TitleOverlay: View {
  let text: String

  var body: some View {
    HStack {
      Text(text)
        .font(.headline)
        .fontDesign(.rounded)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding([.horizontal, .top], 12)
  }
}

/// Displays the cuisine bubble and optional link icon.
private struct InfoOverlay: View {
  let recipe: Recipe

  var body: some View {
    VStack {
      Spacer()
      HStack {
        BubbleChip(text: recipe.cuisine.displayName)
          .frame(maxWidth: .infinity, alignment: .leading)
        if recipe.sourceURL != nil || recipe.youtubeURL != nil {
          BubbleChip(icon: "link")
        }
      }
    }
    .padding([.horizontal, .bottom], 12)
  }
}

#Preview {
  RecipeCard(recipe: MockRecipe.sample)
  .padding()
}
