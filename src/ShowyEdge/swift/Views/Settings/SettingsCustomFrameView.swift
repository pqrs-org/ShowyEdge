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

          customFrameSettings
            .disabled(!userSettings.useCustomFrame)
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
          Grid(alignment: .leadingFirstTextBaseline) {
            GridRow {
              Text("Position:")
                .gridColumnAlignment(.trailing)

              Picker(selection: $userSettings.customFrameOrigin, label: Text("Position:")) {
                Text("Upper-Left").tag(0)
                Text("Lower-Left").tag(1)
                Text("Upper-Right").tag(2)
                Text("Lower-Right").tag(3)
              }
              .labelsHidden()
            }

            GridRow {
              Text("X:")

              HStack {
                DoubleTextField(
                  value: $userSettings.customFrameLeft,
                  range: -10000...10000,
                  step: 100,
                  maximumFractionDigits: 1,
                  width: 50)

                Text("pt")
              }
            }

            GridRow {
              Text("Y:")

              HStack {
                DoubleTextField(
                  value: $userSettings.customFrameTop,
                  range: -10000...10000,
                  step: 100,
                  maximumFractionDigits: 1,
                  width: 50)

                Text("pt")
              }
            }
          }
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
