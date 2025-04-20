import SwiftUI

struct SettingsFollowActiveWindowView: View {
  @EnvironmentObject private var userSettings: UserSettings

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Follow Active Window")) {
        VStack(alignment: .leading, spacing: 10.0) {
          Toggle(isOn: $userSettings.followActiveWindow) {
            Text("Follow active window position (Default: off)")
          }
          .switchToggleStyle()

          if userSettings.followActiveWindow {
            GroupBox(label: Text("Options")) {
              VStack(alignment: .leading, spacing: 10.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                  Toggle(isOn: $userSettings.followFinderActiveWindow) {
                    Text("Follow Finder window (Default: off)")
                  }
                  .switchToggleStyle()

                  Text(
                    "Enabling this setting may cause the indicator position to become incorrect when the desktop is focused."
                  )
                  .font(.caption)
                }
              }
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox(label: Text("Minimum size of a window to be followed")) {
              VStack(alignment: .leading, spacing: 10.0) {
                Grid(alignment: .leadingFirstTextBaseline) {
                  GridRow {
                    Text("Width:")
                      .gridColumnAlignment(.trailing)

                    DoubleTextField(
                      value: $userSettings.minWindowWidthToFollowActiveWindow,
                      range: 0...10000,
                      step: 10,
                      maximumFractionDigits: 1,
                      width: 50)
                  }

                  GridRow {
                    Text("Height:")

                    DoubleTextField(
                      value: $userSettings.minWindowHeightToFollowActiveWindow,
                      range: 0...10000,
                      step: 10,
                      maximumFractionDigits: 1,
                      width: 50)
                  }
                }
              }
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}
