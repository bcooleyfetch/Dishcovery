//
//  RecipeView.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import SwiftUI

struct RecipeView: View {
  @StateObject private var viewModel: RecipeViewModel = .init()

  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.recipes) { recipe in
          HStack {
            AsyncImage(url: recipe.photoURLSmall) { phase in
              if let image = phase.image {
                image
                  .resizable()
                  .scaledToFit()
              } else if phase.error != nil {
                ZStack {
                  Color.clear.background(.regularMaterial)
                  Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
                }
              } else {
                ZStack {
                  Color.clear.background(.regularMaterial)
                  ProgressView()
                }
              }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            VStack(alignment: .leading) {
              Text(recipe.name)
                .font(.headline)
              Text(recipe.cuisine)
                .font(.subheadline)
            }
            .padding(.leading)
          }
        }
      }
      .navigationTitle("Recipes")
      .refreshable {
        await self.viewModel.fetchRecipies()
      }
      .overlay {
        if self.viewModel.recipes.isEmpty {
          VStack {
            Text("No recipes found.")
            Text("Please try again later.")
          }
          .padding()
        }
      }
    }
  }
}

#Preview {
  RecipeView()
}
