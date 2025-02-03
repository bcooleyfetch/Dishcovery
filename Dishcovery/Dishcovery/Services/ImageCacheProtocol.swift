//
//  ImageCacheProtocol.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// A protocol defining the image caching behavior to allow for dependency injection and testing.
protocol ImageCacheProtocol: Actor {
  /// Loads an image from memory, disk, or network.
  /// - Parameter url: The URL of the image.
  /// - Returns: The cached or downloaded image, or `nil` if unavailable.
  func load(url: URL) async -> UIImage?

  /// Removes an image from both memory and disk cache.
  /// - Parameter url: The URL of the image to remove.
  func remove(url: URL) async

  /// Checks if an image exists in either memory or disk cache.
  /// - Parameter url: The URL of the image to check.
  /// - Returns: `true` if the image exists, otherwise `false`.
  func exists(url: URL) async -> Bool
}
