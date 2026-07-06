import SwiftUI

struct SettingsCustomFrameView: View {
  @EnvironmentObject private var userSettings: UserSettings

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Custom Frame")) {
        VStack(alignment: .leading, spacing: 25.0) {
          Toggle(isOn: $userSettings.useCustomFrame) {
            Text("Use custom frame (Default: off)")
          }
          .switchToggleStyle()

          if userSettings.useCustomFrame {
            customFrameSettings
          }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }

  var customFrameSettings: some View {
    VStack(alignment: .leading, spacing: 15.0) {
      HStack(alignment: .top) {
        GroupBox(label: Text("Size")) {
          Grid(alignment: .leadingFirstTextBaseline) {
            GridRow {
              Text("Width:")
                .gridColumnAlignment(.trailing)

              DoubleTextField(
                value: $userSettings.customFrameWidth,
                range: 0...10000,
                step: 10,
                maximumFractionDigits: 1,
                width: 50)

              CustomFrameUnitPicker(value: $userSettings.customFrameWidthUnit)
            }

            GridRow {
              Text("Height:")

              DoubleTextField(
                value: $userSettings.customFrameHeight,
                range: 0...10000,
                step: 10,
                maximumFractionDigits: 1,
                width: 50)

              CustomFrameUnitPicker(value: $userSettings.customFrameHeightUnit)
            }
          }
          .padding()
        }

        GroupBox(label: Text("Origin")) {
          CustomFrameOriginSettingsView(
            origin: $userSettings.customFrameOrigin,
            top: $userSettings.customFrameTop,
            left: $userSettings.customFrameLeft,
            step: 100
          )
          .padding()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      GroupBox(label: Text("Shape")) {
        VStack {
          Toggle(isOn: $userSettings.customFramePillShape) {
            Text("Use pill shape (Default: off)")
          }
          .switchToggleStyle()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}
