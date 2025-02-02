//
//  RecipeViewModel.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
  @Published var recipes: [Recipe] = []

  private let apiService: APIServiceProtocol

  init(apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
    Task { await self.fetchRecipies()}
  }

  func fetchRecipies() async {
    let fetchedRecipes = await self.apiService.fetchRecipies()
    DispatchQueue.main.async {
      self.recipes = fetchedRecipes
    }
  }
}
