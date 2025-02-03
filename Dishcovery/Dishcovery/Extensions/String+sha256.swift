//
//  String+sha256.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

import CryptoKit
import Foundation

extension String {
  /// Compute a SHA-256 hash of the string; used for naming cached image files.
  var sha256: String {
    let data = Data(self.utf8)
    let hash = SHA256.hash(data: data)
    return hash.map { String(format: "%02x", $0) }.joined()
  }
}
