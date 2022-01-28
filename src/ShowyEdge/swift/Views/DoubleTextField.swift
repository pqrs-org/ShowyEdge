import SwiftUI

struct DoubleTextField: View {
  @Binding var value: Double

  private let step: Double
  private let range: ClosedRange<Double>
  private let width: CGFloat
  private let formatter: NumberFormatter

  init(
    value: Binding<Double>,
    range: ClosedRange<Double>,
    step: Double,
    width: CGFloat
  ) {
    _value = value
    self.step = step
    self.range = range
    self.width = width

    formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimum = NSNumber(value: range.lowerBound)
    formatter.maximum = NSNumber(value: range.upperBound)
  }

  var body: some View {
    HStack(spacing: 0) {
      TextField("", value: $value, formatter: formatter).frame(width: width)

      Stepper(
        value: $value,
        in: range,
        step: step
      ) {
        Text("")
      }
    }
  }
}
