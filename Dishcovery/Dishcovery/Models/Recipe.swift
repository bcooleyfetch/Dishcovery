//
//  Recipe.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import Foundation

/// Represents a recipe with various attributes including cuisine, name, and image URLs.
struct Recipe: Identifiable, Decodable {
  let id: UUID
  let cuisine: Cuisine
  let name: String
  let photoURLSmall: URL?
  let photoURLLarge: URL?
  let sourceURL: URL?
  let youtubeURL: URL?
  
  /// Defines the coding keys used for decoding JSON responses.
  enum CodingKeys: String, CodingKey {
    case id = "uuid"
    case cuisine
    case name
    case photoURLSmall = "photo_url_small"
    case photoURLLarge = "photo_url_large"
    case sourceURL = "source_url"
    case youtubeURL = "youtube_url"
  }
  
  /// Custom initializer to decode from JSON and ensure a valid UUID.
  /// - Parameter decoder: The decoder used to parse JSON data.
  /// - Throws: An error if decoding fails or if the UUID is invalid.
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let idString = try container.decode(String.self, forKey: .id)
    guard let uuid = UUID(uuidString: idString) else {
      throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string.")
    }
    
    self.id = uuid
    let cuisineString = try container.decode(String.self, forKey: .cuisine)
    self.cuisine = Cuisine.from(cuisineString)
    self.name = try container.decode(String.self, forKey: .name)
    self.photoURLLarge = try? container.decode(URL.self, forKey: .photoURLLarge)
    self.photoURLSmall = try? container.decode(URL.self, forKey: .photoURLSmall)
    self.sourceURL = try? container.decode(URL.self, forKey: .sourceURL)
    self.youtubeURL = try? container.decode(URL.self, forKey: .youtubeURL)
  }
  
  /// Convenience initializer for manually creating `Recipe` instances.
  /// - Parameters:
  ///   - id: Unique identifier (default is a new UUID).
  ///   - cuisine: The cuisine type as a string (default is an empty string).
  ///   - name: The name of the recipe (default is an empty string).
  ///   - photoURLSmall: Optional small-sized image URL.
  ///   - photoURLLarge: Optional large-sized image URL.
  ///   - sourceURL: Optional source URL for the recipe.
  ///   - youtubeURL: Optional YouTube URL for the recipe.
  init(
    id: UUID = UUID(),
    cuisine: String = "",
    name: String = "",
    photoURLSmall: URL? = nil,
    photoURLLarge: URL? = nil,
    sourceURL: URL? = nil,
    youtubeURL: URL? = nil
  ) {
    self.id = id
    self.cuisine = Cuisine.from(cuisine)
    self.name = name
    self.photoURLSmall = photoURLSmall
    self.photoURLLarge = photoURLLarge
    self.sourceURL = sourceURL
    self.youtubeURL = youtubeURL
  }
}

  /// Represents the structure of the API response containing an array of recipes.
struct RecipeResponse: Decodable {
  /// The list of recipes returned from the API.
  let recipes: [Recipe]
}
