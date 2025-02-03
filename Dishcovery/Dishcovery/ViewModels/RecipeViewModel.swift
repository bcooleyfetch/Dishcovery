//
//  RecipeViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation
import SwiftUI

internal enum ViewState {
  case loading
  case apiError
  case noApiResults
  case noFilteredResults
  case showingRecipes
}

/// ViewModel responsible for managing and filtering recipes in the grid view.
@MainActor
class RecipeViewModel: ObservableObject {
  /// The currently selected recipe.
  @Published var selectedRecipe: Recipe?
  /// The current search query.
  @Published var searchQuery: String = "" {
    didSet { filterRecipes() }
  }
  /// The set of selected cuisines for filtering.
  @Published var selectedCuisines: Set<Cuisine> = [] {
    didSet { filterRecipes() }
  }
  /// List of all fetched recipes.
  @Published private(set) var recipes: [Recipe] = []
  /// List of recipes filtered based on search and selected cuisines.
  @Published private(set) var filteredRecipes: [Recipe] = []
  /// Indicates whether the API threw an error after fetching for recipes.
  @Published private var apiErrorOccurred: Bool = false
  /// Indicates whether the API is fetching recipes and still loading that data.
  @Published private var isLoading: Bool = true

  /// API service for fetching recipes.
  private let apiService: APIServiceProtocol

  /// Determines the current view state for the UI.
  var currentState: ViewState {
    if isLoading {
      return .loading
    } else if apiErrorOccurred {
      return .apiError
    } else if recipes.isEmpty {
      return .noApiResults
    } else if filteredRecipes.isEmpty {
      return .noFilteredResults
    } else {
      return .showingRecipes
    }
  }

  /// Initializes the ViewModel with an API service.
  /// - Parameter apiService: The API service used to fetch recipes.
  init(apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
    Task { await fetchRecipies() }
  }

  /// Fetches recipes from the API.
  func fetchRecipies() async {
    isLoading = true

    do {
      let fetchedRecipes = try await apiService.fetchRecipies()
      DispatchQueue.main.async {
        self.apiErrorOccurred = false
        self.recipes = fetchedRecipes
        self.filterRecipes()
      }
    } catch {
      DispatchQueue.main.async {
        self.apiErrorOccurred = true
        self.recipes = []
      }
    }

    DispatchQueue.main.async {
      self.isLoading = false
    }
  }

  /// Updates the selected recipe, triggering UI updates.
  /// - Parameter recipe: The recipe to select or `nil` to deselect.
  func selectRecipe(_ recipe: Recipe?) {
    self.selectedRecipe = recipe
  }
  
  /// Toggles a cuisine filter.
  /// - Parameter cuisine: The cuisine to toggle.
  func toggleCuisineFilter(_ cuisine: Cuisine) {
    triggerHapticFeedback()
    if selectedCuisines.contains(cuisine) {
      selectedCuisines.remove(cuisine)
    } else {
      selectedCuisines.insert(cuisine)
    }
  }

  /// Triggers a light haptic feedback when a cuisine filter chip is tapped.
  private func triggerHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()
    generator.impactOccurred()
  }

  /// Filters recipes based on the current search query and selected cuisines.
  private func filterRecipes() {
    withAnimation(.easeInOut(duration: 0.3)) {
      filteredRecipes = recipes.filter { recipe in
        let matchesSearch = searchQuery.isEmpty ||
        recipe.name.localizedCaseInsensitiveContains(searchQuery) ||
        recipe.cuisine.id.localizedCaseInsensitiveContains(searchQuery)

        let matchesCuisine = selectedCuisines.isEmpty ||
        selectedCuisines.contains(Cuisine.from(recipe.cuisine.id))

        return matchesSearch && matchesCuisine
      }
    }
  }
}
