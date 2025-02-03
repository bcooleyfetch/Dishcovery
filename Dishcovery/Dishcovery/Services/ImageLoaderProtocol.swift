//
//  ImageLoaderProtocol.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/3/25.
//

import SwiftUI

/// Protocol defining image loading and caching behavior.
protocol ImageLoaderProtocol {
  /// Loads the best available image, prioritizing large images.
  /// - Returns: A cached or downloaded image, or `nil` if unavailable.
  func loadImage() async -> UIImage?

  /// Loads the large image and removes the small one from the cache if necessary.
  /// - Returns: The large image if available, otherwise `nil`.
  func loadLargeImage() async -> UIImage?
}