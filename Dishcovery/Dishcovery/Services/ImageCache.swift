//
//  ImageCache.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import SwiftUI

/// A simple image caching system that stores images in memory and disk for efficient reuse.
actor ImageCache: ImageCacheProtocol {
  private var memoryCache: [String: UIImage] = [:]
  private let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  
  /// Generates a unique cache key for a given URL using SHA-256 hashing.
  /// - Parameter url: The URL of the image.
  /// - Returns: A hashed string representing the cache key.
  private func cacheKey(for url: URL) -> String {
    return url.absoluteString.sha256
  }
  
  func load(url: URL) async -> UIImage? {
    let cacheKey = self.cacheKey(for: url)
    
    // Check memory cache
    if let cachedImage = memoryCache[cacheKey] {
      return cachedImage
    }
    
    // Check disk cache
    let filePath = cacheDirectory.appendingPathComponent(cacheKey)
    if let diskImage = UIImage(contentsOfFile: filePath.path) {
      memoryCache[cacheKey] = diskImage
      return diskImage
    }
    
    // Fetch from network
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        memoryCache[cacheKey] = image
        try data.write(to: filePath)
        return image
      }
    } catch {
      print("Error fetching image: \(error)")
    }
    
    return nil
  }
  
  func remove(url: URL) async {
    let cacheKey = self.cacheKey(for: url)
    let filePath = cacheDirectory.appendingPathComponent(cacheKey)
    
    if FileManager.default.fileExists(atPath: filePath.path) {
      do {
        try FileManager.default.removeItem(at: filePath)
        memoryCache.removeValue(forKey: cacheKey)
      } catch {
        print("Error removing cached image: \(error)")
      }
    }
  }
  
  func exists(url: URL) async -> Bool {
    let cacheKey = self.cacheKey(for: url)
    let filePath = cacheDirectory.appendingPathComponent(cacheKey)
    
    return memoryCache[cacheKey] != nil || FileManager.default.fileExists(atPath: filePath.path)
  }
}
