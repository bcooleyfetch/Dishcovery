//
//  MockImageCache.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import Foundation
import SwiftUI
@testable import Dishcovery

/// A mock implementation of `ImageCacheProtocol` for unit testing.
actor MockImageCache: ImageCacheProtocol {
  var mockStorage: [String: UIImage] = [:]

  func load(url: URL) async -> UIImage? {
    return mockStorage[url.absoluteString]
  }

  func remove(url: URL) async {
    mockStorage.removeValue(forKey: url.absoluteString)
  }

  func exists(url: URL) async -> Bool {
    return mockStorage[url.absoluteString] != nil
  }

  func setImage(_ image: UIImage, for url: URL) async {
    mockStorage[url.absoluteString] = image
  }
}
