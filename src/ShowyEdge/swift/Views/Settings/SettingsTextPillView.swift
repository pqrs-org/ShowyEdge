import SwiftUI

struct SettingsTextPillView: View {
  @EnvironmentObject private var userSettings: UserSettings
  @ObservedObject private var workspaceData = WorkspaceData.shared

  @State private var hoverTextPillLanguageSetting: TextPillLanguageSetting?

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Behavior")) {
        Toggle(
          "Hide on hover",
          isOn: $userSettings.textPillHideOnHover
        )
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      GroupBox(label: Text("Font")) {
        HStack {
          Text("Size:")

          DoubleTextField(
            value: $userSettings.textPillFontSize,
            range: 1...200,
            step: 1,
            maximumFractionDigits: 1,
            width: 50)

          Text("pt")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      HStack(alignment: .top) {
        GroupBox(label: Text("Size")) {
          Grid(alignment: .leadingFirstTextBaseline) {
            GridRow {
              Text("Width:")
                .gridColumnAlignment(.trailing)

              HStack {
                DoubleTextField(
                  value: $userSettings.textPillWidth,
                  range: 1...10000,
                  step: 10,
                  maximumFractionDigits: 1,
                  width: 50)

                Text("pt")
              }
            }

            GridRow {
              Text("Height:")

              HStack {
                DoubleTextField(
                  value: $userSettings.textPillHeight,
                  range: 1...10000,
                  step: 5,
                  maximumFractionDigits: 1,
                  width: 50)

                Text("pt")
              }
            }
          }
          .padding()
        }

        GroupBox(label: Text("Origin")) {
          Grid(alignment: .leadingFirstTextBaseline) {
            GridRow {
              Text("Position:")
                .gridColumnAlignment(.trailing)

              Picker(selection: $userSettings.textPillOrigin, label: Text("Position:")) {
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
                  value: $userSettings.textPillLeft,
                  range: -10000...10000,
                  step: 10,
                  maximumFractionDigits: 1,
                  width: 50)

                Text("pt")
              }
            }

            GridRow {
              Text("Y:")

              HStack {
                DoubleTextField(
                  value: $userSettings.textPillTop,
                  range: -10000...10000,
                  step: 10,
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

      customLanguageSettings
    }
  }

  private var customLanguageSettings: some View {
    let currentInputSourceLocalizedName = workspaceData.getInputSourceLocalizedName(
      inputSourceID: workspaceData.currentInputSourceID)

    return GroupBox(label: Text("Input Source")) {
      VStack(alignment: .leading, spacing: 10.0) {
        if $userSettings.textPillLanguageSettings.count > 0 {
          ScrollViewReader { proxy in
            List {
              ForEach($userSettings.textPillLanguageSettings) { $setting in
                // Make a copy to use it in onHover.
                // (Without copy, the program crashes with an incorrect reference when the profile is deleted.)
                let settingCopy = setting

                VStack(alignment: .leading) {
                  HStack(alignment: .center, spacing: 4) {
                    Text(
                      workspaceData.getInputSourceLocalizedName(
                        inputSourceID: setting.inputSourceID)
                    )
                    .padding(.trailing, 2)
                    .fixedSize(horizontal: false, vertical: true)
                    .if(setting.inputSourceID == workspaceData.currentInputSourceID) {
                      $0.foregroundColor(.accentColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .if(hoverTextPillLanguageSetting == settingCopy) {
                      $0.overlay(
                        RoundedRectangle(cornerRadius: 2)
                          .inset(by: -4)
                          .stroke(
                            Color.accentColor,
                            lineWidth: 2
                          )
                      )
                    }

                    HStack(alignment: .center, spacing: 4) {
                      ColorPicker(
                        "Pill background",
                        selection: $setting.backgroundColor
                      )
                      .labelsHidden()

                      ColorPicker(
                        "Pill text",
                        selection: $setting.foregroundColor
                      )
                      .labelsHidden()

                      TextField("", text: $setting.label)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 70)

                      Button(
                        role: .destructive,
                        action: {
                          userSettings.removeTextPillLanguageSetting(
                            setting.inputSourceID
                          )
                        },
                        label: {
                          Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                        }
                      )
                      .padding(.leading, 10)
                    }
                    .padding(.leading, 10)
                    .onHover { hovering in
                      if hovering {
                        hoverTextPillLanguageSetting = settingCopy
                      } else {
                        if hoverTextPillLanguageSetting == settingCopy {
                          hoverTextPillLanguageSetting = nil
                        }
                      }
                    }
                  }

                  Text(setting.inputSourceID)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                }
              }
            }
            .frame(height: 200)
            .onChange(of: userSettings.textPillLanguageSettings.count) { _ in
              if let first = userSettings.textPillLanguageSettings.first {
                withAnimation {
                  // Reset position when textPillLanguageSettings is added.
                  proxy.scrollTo(first.id, anchor: .top)
                }
              }
            }
          }
        } else {
          Text(currentInputSourceLocalizedName)
            .foregroundColor(.gray)
        }

        Button(
          action: {
            userSettings.appendTextPillLanguageSetting(workspaceData.currentInputSourceID)
          },
          label: {
            Label(
              "Set the text pill for \(currentInputSourceLocalizedName)",
              systemImage: "plus")
          }
        ).disabled(
          userSettings.textPillLanguageSettingIndex(
            inputSourceID: workspaceData.currentInputSourceID) != nil
        )
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
