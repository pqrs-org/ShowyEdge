import SwiftUI

struct PreferencesCustomFrameView: View {
  @ObservedObject var userSettings = UserSettings.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Custom Frame")) {
        VStack(alignment: .leading, spacing: 25.0) {
          Toggle(isOn: $userSettings.useCustomFrame) {
            Text("Use custom frame (Default: off)")
          }

          customFrameSettings
            .disabled(!userSettings.useCustomFrame)
        }.padding()
      }

      Spacer()
    }.padding()
  }

  var customFrameSettings: some View {
    Group {
      GroupBox(label: Text("Size")) {
        HStack {
          Text("Width")

          DoubleTextField(
            value: $userSettings.customFrameWidth,
            range: 0...10000,
            step: 10,
            width: 50)

          CustomFrameUnitPicker(value: $userSettings.customFrameWidthUnit)

          Text("Height").padding(.leading, 40)

          DoubleTextField(
            value: $userSettings.customFrameHeight,
            range: 0...10000,
            step: 10,
            width: 50)

          CustomFrameUnitPicker(value: $userSettings.customFrameHeightUnit)

          Spacer()
        }.padding()
      }

      GroupBox(label: Text("Origin")) {
        VStack(alignment: .leading, spacing: 10.0) {
          Picker(selection: $userSettings.customFrameOrigin, label: Text("")) {
            Text("Upper-Left").tag(0)
            Text("Lower-Left").tag(1)
            Text("Upper-Right").tag(2)
            Text("Lower-Right").tag(3)
          }.frame(width: 200.0)

          HStack {
            Text("Margin-X")

            DoubleTextField(
              value: $userSettings.customFrameLeft,
              range: -10000...10000,
              step: 100,
              width: 50)

            Text("pt")

            Text("Margin-Y").padding(.leading, 40)

            DoubleTextField(
              value: $userSettings.customFrameTop,
              range: -10000...10000,
              step: 100,
              width: 50)

            Text("pt")

            Spacer()
          }
        }.padding()
      }

      GroupBox(label: Text("Shape")) {
        HStack(alignment: .top, spacing: 10.0) {
          Toggle(isOn: $userSettings.customFramePillShape) {
            Text("Use pill shape (Default: off)")
          }

          Spacer()
        }.padding()
      }
    }
  }
}

struct PreferencesCustomFrameView_Previews: PreviewProvider {
  static var previews: some View {
    PreferencesCustomFrameView()
      .previewLayout(.sizeThatFits)
  }
}
