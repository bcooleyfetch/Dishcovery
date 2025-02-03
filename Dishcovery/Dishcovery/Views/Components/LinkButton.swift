//
//  LinkButton.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

/// A styled button that opens a given URL when tapped.
struct LinkButton: View {
  let title: String
  let systemImage: String
  let url: URL
  let color: Color
  
  var body: some View {
    Link(destination: url) {
      Label(title, systemImage: systemImage)
        .font(.headline)
        .fontDesign(.rounded)
        .foregroundStyle(color)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }
}

#Preview {
  LinkButton(
    title: "Visit Google",
    systemImage: "link",
    url: URL(string: "https://www.google.com")!,
    color: .blue
  )
  .padding()
}
