import SwiftUI

struct SettingsIndicatorView: View {
  @EnvironmentObject private var userSettings: UserSettings

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Height")) {
        VStack {
          HStack {
            Text("Indicator Height")

            DoubleTextField(
              value: $userSettings.indicatorHeightPx,
              range: 0...10000,
              step: 5,
              maximumFractionDigits: 1,
              width: 50)

            Text("pt")

            Text("(Default: 5pt)")
          }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      GroupBox(label: Text("Opacity")) {
        VStack {
          Slider(
            value: $userSettings.indicatorOpacity,
            in: 0...100,
            step: 5,
            minimumValueLabel: Text("Clear"),
            maximumValueLabel: Text("Colored (Default)"),
            label: {
              Text("")
            }
          )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      GroupBox(label: Text("Options")) {
        VStack(alignment: .leading, spacing: 10.0) {
          Toggle(isOn: $userSettings.hideIfMenuBarIsHidden) {
            Text("Hide indicator if the menu bar is hidden (Default: off)")
          }
          .switchToggleStyle()

          VStack(alignment: .leading, spacing: 0.0) {
            Toggle(isOn: $userSettings.showIndicatorBehindAppWindows) {
              Text("Show indicator behind app windows (Default: off)")
            }
            .switchToggleStyle()

            Text("(This option do not work properly when the menu bar is hidden.)")
          }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      GroupBox(label: Text("Colors Layout Orientation")) {
        VStack {
          Picker(selection: $userSettings.colorsLayoutOrientation, label: Text("")) {
            Text("Horizontal (Default)").tag("horizontal")
            Text("Vertical").tag("vertical")
          }
          .pickerStyle(.radioGroup)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}
