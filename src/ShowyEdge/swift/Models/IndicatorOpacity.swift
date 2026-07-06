import CoreGraphics

enum IndicatorOpacity {
  // If indicator size is too large, set transparency in order to avoid the indicator hides all windows.
  static func adjusted(percent: Double, size: CGSize) -> Double {
    var opacity = min(max(percent / 100, 0), 1)

    if size.width > 100,
      size.height > 100
    {
      opacity = min(opacity, 0.8)
    }

    return opacity
  }

  // Use the most transparent opacity required by any indicator window.
  // If there are no windows, fall back to the clamped user setting.
  static func adjusted<Sizes: Sequence>(percent: Double, sizes: Sizes) -> Double
  where Sizes.Element == CGSize {
    sizes.reduce(adjusted(percent: percent, size: .zero)) { opacity, size in
      min(opacity, adjusted(percent: percent, size: size))
    }
  }
}
