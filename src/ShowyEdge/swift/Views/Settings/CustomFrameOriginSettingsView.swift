import SwiftUI

struct CustomFrameOriginSettingsView: View {
  @Binding var origin: Int
  @Binding var top: Double
  @Binding var left: Double

  let step: Double

  var body: some View {
    Grid(alignment: .leadingFirstTextBaseline) {
      GridRow {
        Text("Position:")
          .gridColumnAlignment(.trailing)

        Picker(selection: $origin, label: Text("Position:")) {
          ForEach(CustomFrameOrigin.allCases, id: \.rawValue) { origin in
            Text(originLabel(origin)).tag(origin.rawValue)
          }
        }
        .labelsHidden()
      }

      GridRow {
        Text(verticalOffsetLabel)

        HStack {
          DoubleTextField(
            value: $top,
            range: -10000...10000,
            step: step,
            maximumFractionDigits: 1,
            width: 50)

          Text("pt")
        }
        .fixedSize(horizontal: true, vertical: false)
      }

      GridRow {
        Text(horizontalOffsetLabel)

        HStack {
          DoubleTextField(
            value: $left,
            range: -10000...10000,
            step: step,
            maximumFractionDigits: 1,
            width: 50)

          Text("pt")
        }
        .fixedSize(horizontal: true, vertical: false)
      }
    }
  }

  private var horizontalOffsetLabel: String {
    switch CustomFrameOrigin(rawValue: origin) {
    case .upperRight, .lowerRight:
      return "Right:"
    default:
      return "Left:"
    }
  }

  private var verticalOffsetLabel: String {
    switch CustomFrameOrigin(rawValue: origin) {
    case .lowerLeft, .lowerRight:
      return "Lower:"
    default:
      return "Upper:"
    }
  }

  private func originLabel(_ origin: CustomFrameOrigin) -> String {
    switch origin {
    case .upperLeft:
      return "Upper-Left"
    case .lowerLeft:
      return "Lower-Left"
    case .upperRight:
      return "Upper-Right"
    case .lowerRight:
      return "Lower-Right"
    }
  }
}
