//
//  Recipe.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
  let id: UUID
  let name: String
  let cuisine: String
  let photoURLSmall: URL?
  let photoURLLarge: URL?
  let sourceURL: URL?
  let youtubeURL: URL?

  enum CodingKeys: String, CodingKey {
    case id = "uuid"
    case name, cuisine
    case photoURLSmall = "photo_url_small"
    case photoURLLarge = "photo_url_large"
    case sourceURL = "source_url"
    case youtubeURL = "youtube_url"
  }
}

struct RecipeResponse: Codable {
  let recipes: [Recipe]
}
