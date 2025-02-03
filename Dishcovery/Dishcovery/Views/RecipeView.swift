//
//  RecipeView.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import SwiftUI

/// Displays a grid of recipes with filtering, searching, and context menu support.
struct RecipeView: View {
  @StateObject private var viewModel = RecipeViewModel()
  let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)

  /// Configures custom fonts for navigation bar titles.
  init() {
    let largeDescriptor = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: .largeTitle)
      .withSymbolicTraits(.traitBold)!
      .withDesign(.rounded)!

    let titleDescriptor = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: .headline)
      .withSymbolicTraits(.traitBold)!
      .withDesign(.rounded)!

    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont(descriptor: largeDescriptor, size: 0)
    ]

    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont(descriptor: titleDescriptor, size: 0)
    ]
  }

  var body: some View {
    NavigationView {
      ScrollView {
        CuisineFilterBar(viewModel: viewModel)

        if viewModel.noResults {
          NoResultsView(helperText: viewModel.searchQuery)
        } else {
          RecipeGridView(viewModel: viewModel, columns: columns)
        }
      }
      .navigationTitle("Recipes")
      .navigationBarTitleDisplayMode(.large)
      .refreshable {
        await viewModel.fetchRecipies()
      }
      .searchable(
        text: $viewModel.searchQuery,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by name or cuisine"
      )
      .sheet(item: $viewModel.selectedRecipe) { recipe in
        RecipeBottomSheet(recipe: recipe) {
          viewModel.selectedRecipe = nil
        }
        .applyBottomSheetModifiers()
      }
    }
  }
}

/// Displays a horizontal scrollable filter bar for cuisines.
private struct CuisineFilterBar: View {
  @ObservedObject var viewModel: RecipeViewModel

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(Cuisine.allCases, id: \.self) { cuisine in
          BubbleChip(
            text: cuisine.displayName,
            backgroundColor: cuisine.backgroundColor,
            isSelected: viewModel.selectedCuisines.contains(cuisine),
            onTap: { viewModel.toggleCuisineFilter(cuisine) }
          )
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 8)
    }
  }
}

/// Displays a placeholder when no recipes match the search or filter criteria.
private struct NoResultsView: View {
  let helperText: String

  var body: some View {
    if #available(iOS 17, *) {
      ContentUnavailableView(
        "No Results for \"\(helperText)\"",
        systemImage: "magnifyingglass"
      )
      .fontDesign(.rounded)
    } else {
      VStack(spacing: 12) {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 56))
          .fontDesign(.rounded)
          .foregroundStyle(.secondary)
        Text("No Results for \"\(helperText)\"")
          .font(.title2)
          .fontWeight(.bold)
          .fontDesign(.rounded)
          .foregroundStyle(.primary)
      }
      .frame(maxWidth: .infinity, minHeight: 200)
    }
  }
}

/// Displays a list of filtered recipes in a grid layout.
private struct RecipeGridView: View {
  @ObservedObject var viewModel: RecipeViewModel
  let columns: [GridItem]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(viewModel.filteredRecipes) { recipe in
        RecipeCard(recipe: recipe)
          .frame(minHeight: 100)
          .contextMenu { RecipeContextMenu(recipe: recipe) }
          .onTapGesture { viewModel.selectRecipe(recipe) }
      }
    }
    .padding(.horizontal, 16)
  }
}

/// Provides a context menu with actions based on available URLs.
private struct RecipeContextMenu: View {
  let recipe: Recipe

  var body: some View {
    let actions: [(title: String, url: URL, systemImage: String)] = [
      recipe.sourceURL.map { ("View Recipe", $0, "link") },
      recipe.youtubeURL.map { ("Watch Video", $0, "play.circle") }
    ]
    .compactMap { $0 }

    if actions.isEmpty {
      Button("No Actions Available", action: {})
        .disabled(true)
    } else {
      ForEach(actions, id: \.url) { action in
        Button {
          UIApplication.shared.open(action.url)
        } label: {
          Label(action.title, systemImage: action.systemImage)
        }
      }
    }
  }
}

extension View {
  /// Applies consistent styling for bottom sheets across different iOS versions.
  @ViewBuilder
  func applyBottomSheetModifiers() -> some View {
    if #available(iOS 16.4, *) {
      self
        .presentationDetents([.fraction(0.35)])
        .presentationBackground(.thinMaterial)
        .presentationCornerRadius(40)
        .presentationDragIndicator(.hidden)
    } else {
      self
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.hidden)
    }
  }
}

#Preview {
  RecipeView()
}
