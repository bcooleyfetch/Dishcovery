//
//  BubbleChip.swift
//  Dishcovery
//
//  Created by Brad Cooley on 2/2/25.
//

import SwiftUI

struct BubbleChip: View {
  let text: String?
  let icon: String?
  let backgroundColor: Color?
  let isSelected: Bool
  let onTap: (() -> Void)?
  
  init(
    text: String? = nil,
    icon: String? = nil,
    backgroundColor: Color? = nil,
    isSelected: Bool = false,
    onTap: (() -> Void)? = nil
  ) {
    self.text = text
    self.icon = icon
    self.backgroundColor = backgroundColor
    self.isSelected = isSelected
    self.onTap = onTap
  }
  
  var body: some View {
    content
      .padding(.horizontal, text != nil ? 12 : 4)
      .padding(.vertical, text != nil ? 4 : 4)
      .background(
        RoundedRectangle(cornerRadius: .infinity)
          .fill(.regularMaterial)
          .overlay(
            RoundedRectangle(cornerRadius: .infinity)
              .fill(backgroundColor ?? .clear)
              .opacity(isSelected ? 0.5 : 0.3)
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: .infinity)
          .stroke(backgroundColor?.opacity(isSelected ? 0.8 : 0) ?? .clear, lineWidth: 2)
      )
      .clipShape(RoundedRectangle(cornerRadius: .infinity))
      .ifLet(onTap) { view, action in
        Button(action: action) {
          view
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
      }
  }
  
  @ViewBuilder
  var content: some View {
    if let icon = icon {
      Image(systemName: icon)
        .font(.subheadline)
        .fontDesign(.rounded)
        .fontWeight(.semibold)
        .foregroundStyle(.secondary)
    } else if let text = text {
      Text(text)
        .font(.subheadline)
        .fontDesign(.rounded)
        .fontWeight(.semibold)
        .foregroundStyle(isSelected ? .primary : .secondary)
        .truncationMode(.tail)
        .lineLimit(1)
    }
  }
}

extension View {
  /// Applies a transformation only if the given optional value exists.
  @ViewBuilder
  func ifLet<T>(_ value: T?, transform: (Self, T) -> some View) -> some View {
    if let value = value {
      transform(self, value)
    } else {
      self
    }
  }
}

#Preview("Cuisine Bubble") {
  BubbleChip(text: "🇬🇧 British")
    .padding()
}

#Preview("Icon Bubble") {
  BubbleChip(icon: "star.fill")
    .padding()
}

#Preview("Filter Bubble") {
  BubbleChip(text: "🇺🇸 American", backgroundColor: .red, isSelected: true)
    .padding()
}
