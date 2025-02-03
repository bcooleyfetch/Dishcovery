//
//  DishcoveryTests.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import XCTest

/// A master test suite that aggregates all unit tests for the project.
final class DishcoveryTests: XCTestCase {
  
  /// Runs all test cases in the project.
  func testAllSuites() {
    let testSuites: [XCTestCase.Type] = [
      APIServiceTests.self,
      ImageCacheTests.self,
      ImageLoaderTests.self
    ]
    
    for testSuite in testSuites {
      testSuite.defaultTestSuite.run()
    }
  }
}
