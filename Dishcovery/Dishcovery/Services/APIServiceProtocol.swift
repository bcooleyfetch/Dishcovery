//
//  APIServiceProtocol.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/1/25.
//

protocol APIServiceProtocol {
  func fetchRecipies() async -> [Recipe]
}
