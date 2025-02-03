//
//  Cuisine.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import SwiftUI

/// Represents different types of cuisine.
/// Supports predefined cuisines as well as a generic "Other" category with a custom name.
enum Cuisine: Equatable, Identifiable, Hashable, CaseIterable {
  case british, american, french, canadian, other(String)

  /// Returns a unique string identifier for each cuisine.
  var id: String {
    switch self {
    case .british: return "British"
    case .american: return "American"
    case .french: return "French"
    case .canadian: return "Canadian"
    case .other(let name): return name
    }
  }

  var displayName: String {
    switch self {
    case .british: return "🇬🇧 British"
    case .american: return "🇺🇸 American"
    case .french: return "🇫🇷 French"
    case .canadian: return "🇨🇦 Canadian"
    case .other(let name): return "🌍 \(name)"
    }
  }

  /// Returns a background color associated with the cuisine.
  var backgroundColor: Color {
    switch self {
    case .british: return Color.blue
    case .american: return Color.red
    case .french: return Color.indigo
    case .canadian: return Color.gray
    default: return Color.green
    }
  }

  /// Provides all predefined cuisine cases, including "Other" as a general category.
  static var allCases: [Cuisine] {
    return [.british, .american, .french, .canadian, .other("Other")]
  }

  /// Converts a string representation of a cuisine into a `Cuisine` enum case.
  /// - Parameter string: A string representing a cuisine name.
  /// - Returns: A corresponding `Cuisine` case, or `.other(string)` if not recognized.
  static func from(_ string: String) -> Cuisine {
    let normalized = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    switch normalized {
    case "british": return .british
    case "american": return .american
    case "french": return .french
    case "canadian": return .canadian
    default: return .other(string)
    }
  }
}
