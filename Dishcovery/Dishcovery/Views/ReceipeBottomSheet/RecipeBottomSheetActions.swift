import SwiftUI

/// Displays available action buttons based on the recipe's links.
struct RecipeBottomSheetActions: View {
  let recipe: Recipe

  var body: some View {
    VStack(spacing: 16) {
      actionSection
      linkButtons
    }
  }

  /// Section header for the action buttons.
  private var actionSection: some View {
    HStack {
      Text("Explore")
        .font(.headline)
        .fontDesign(.rounded)
        .foregroundStyle(.primary.opacity(0.6))
        .padding(.leading)
      Spacer()
    }
  }

  /// Displays action buttons if links are available.
  private var linkButtons: some View {
    HStack(spacing: 16) {
      if let sourceURL = recipe.sourceURL {
        LinkButton(title: "View Recipe", systemImage: "link", url: sourceURL, color: .blue)
      }
      if let youtubeURL = recipe.youtubeURL {
        LinkButton(title: "Watch Video", systemImage: "play.circle", url: youtubeURL, color: .red)
      }
    }
    .padding(.horizontal)
  }
}