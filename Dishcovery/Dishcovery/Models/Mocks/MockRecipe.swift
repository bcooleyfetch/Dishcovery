//
//  MockRecipe.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import Foundation

/// Provides mock `Recipe` objects for unit testing and previews.
struct MockRecipe {
  /// A sample recipe for testing purposes.
  static let sample = Recipe(
    id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
    cuisine: "British",
    name: "Fish & Chips",
    photoURLSmall: URL(string: "https://example.com/small.jpg"),
    photoURLLarge: URL(string: "https://example.com/large.jpg"),
    sourceURL: URL(string: "https://example.com/recipe"),
    youtubeURL: URL(string: "https://youtube.com/watch?v=dQw4w9WgXcQ")
  )

  /// A list of sample recipes.
  static let sampleList: [Recipe] = [
    Recipe(
      id: UUID(uuidString: "111e2222-e89b-12d3-a456-426614174001")!,
      cuisine: "French",
      name: "Coq au Vin",
      photoURLSmall: URL(string: "https://example.com/french-small.jpg"),
      photoURLLarge: URL(string: "https://example.com/french-large.jpg"),
      sourceURL: URL(string: "https://example.com/french-recipe"),
      youtubeURL: URL(string: "https://youtube.com/watch?v=abcdef")
    ),
    Recipe(
      id: UUID(uuidString: "222e3333-e89b-12d3-a456-426614174002")!,
      cuisine: "American",
      name: "Cheeseburger",
      photoURLSmall: URL(string: "https://example.com/american-small.jpg"),
      photoURLLarge: URL(string: "https://example.com/american-large.jpg"),
      sourceURL: URL(string: "https://example.com/american-recipe"),
      youtubeURL: URL(string: "https://youtube.com/watch?v=123456")
    ),
    Recipe(
      id: UUID(uuidString: "333e4444-e89b-12d3-a456-426614174003")!,
      cuisine: "Canadian",
      name: "Poutine",
      photoURLSmall: URL(string: "https://example.com/canadian-small.jpg"),
      photoURLLarge: URL(string: "https://example.com/canadian-large.jpg"),
      sourceURL: URL(string: "https://example.com/canadian-recipe"),
      youtubeURL: URL(string: "https://youtube.com/watch?v=789xyz")
    )
  ]
}
