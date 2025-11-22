import SwiftUI

@MainActor
class IndicatorColors: ObservableObject {
  static let shared = IndicatorColors()

  @Published var colors: (Color, Color, Color) = (.clear, .clear, .clear)
}
