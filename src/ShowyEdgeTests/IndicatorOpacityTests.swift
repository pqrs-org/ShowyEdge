import CoreGraphics
import Testing

@testable import ShowyEdge

struct IndicatorOpacityTests {
  @Test func clampsPercentToOpacityRange() {
    #expect(IndicatorOpacity.adjusted(percent: -10, size: .zero) == 0)
    #expect(IndicatorOpacity.adjusted(percent: 150, size: .zero) == 1)
  }

  @Test func keepsConfiguredOpacityForSmallIndicator() {
    #expect(IndicatorOpacity.adjusted(percent: 75, size: CGSize(width: 100, height: 100)) == 0.75)
  }

  @Test func limitsOpacityForLargeIndicator() {
    #expect(IndicatorOpacity.adjusted(percent: 100, size: CGSize(width: 101, height: 101)) == 0.8)
  }
}
