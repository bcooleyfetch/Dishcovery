
import SwiftUI
@testable import Dishcovery

/// A mock implementation of `ImageLoaderProtocol` for unit testing.
actor MockImageLoader: ImageLoaderProtocol {
  var mockImage: UIImage?
  var shouldReturnNil: Bool = false

  func loadImage() async -> UIImage? {
    return shouldReturnNil ? nil : mockImage
  }

  func loadLargeImage() async -> UIImage? {
    return shouldReturnNil ? nil : mockImage
  }
}