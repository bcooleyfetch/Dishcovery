//
//  RecipeGridViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation
import SwiftUI

/// ViewModel responsible for managing and filtering recipes in the grid view.
@MainActor
class RecipeGridViewModel: ObservableObject {
  /// List of all fetched recipes.
  @Published var recipes: [Recipe] = []
  /// List of recipes filtered based on search and selected cuisines.
  @Published var filteredRecipes: [Recipe] = []
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
  /// Indicates whether there are no results after filtering.
  @Published var noResults: Bool = false

  /// API service for fetching recipes.
  private let apiService: APIServiceProtocol

  /// Initializes the ViewModel with an API service.
  /// - Parameter apiService: The API service used to fetch recipes.
  init(apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
    Task { await fetchRecipies() }
  }

  /// Fetches recipes from the API and updates the list.
  func fetchRecipies() async {
    let fetchedRecipes = try? await apiService.fetchRecipies()
    DispatchQueue.main.async {
      self.recipes = fetchedRecipes ?? []
      self.filterRecipes()
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
    if selectedCuisines.contains(cuisine) {
      selectedCuisines.remove(cuisine)
    } else {
      selectedCuisines.insert(cuisine)
    }
  }

  /// Filters recipes based on the current search query and selected cuisines.
  private func filterRecipes() {
    withAnimation(.easeInOut(duration: 0.3)) {
      filteredRecipes = recipes.filter { recipe in
        let matchesSearch = searchQuery.isEmpty ||
        recipe.name.localizedCaseInsensitiveContains(searchQuery) ||
        recipe.cuisine.id.localizedCaseInsensitiveContains(searchQuery)

        let matchesCuisine = selectedCuisines.isEmpty ||
        (selectedCuisines.contains(.other("Other")) && !Cuisine.allCases.contains(Cuisine.from(recipe.cuisine.id))) ||
        selectedCuisines.contains(Cuisine.from(recipe.cuisine.id))

        return matchesSearch && matchesCuisine
      }
    }
    noResults = filteredRecipes.isEmpty
  }
}
