import SwiftUI

struct SettingsMainView: View {
  @Binding var showMenuBarExtra: Bool

  @EnvironmentObject private var userSettings: UserSettings
  @ObservedObject private var openAtLogin = OpenAtLogin.shared
  @ObservedObject private var workspaceData = WorkspaceData.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Basic")) {
        VStack(alignment: .leading, spacing: 10.0) {
          Toggle(isOn: $openAtLogin.registered) {
            Text("Open at login")
          }
          .switchToggleStyle()
          .disabled(openAtLogin.developmentBinary)
          .onChange(of: openAtLogin.registered) { value in
            OpenAtLogin.shared.update(register: value)
          }

          if openAtLogin.error.count > 0 {
            VStack {
              Label(
                openAtLogin.error,
                systemImage: "exclamationmark.circle.fill"
              )
              .padding()
            }
            .modifier(ErrorBorder(padding: 4.0))
          }

          Toggle(isOn: $showMenuBarExtra) {
            Text("Show icon in menu bar")
          }
          .switchToggleStyle()

          Toggle(isOn: $userSettings.showAdditionalMenuItems) {
            Text("Show additional menu items")
          }
          .switchToggleStyle()
          .disabled(!showMenuBarExtra)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      let currentInputSourceLocalizedName = workspaceData.getInputSourceLocalizedName(
        inputSourceID: workspaceData.currentInputSourceID)

      GroupBox(label: Text("Color")) {
        VStack(alignment: .leading, spacing: 10.0) {
          if !userSettings.customizedLanguageColors.isEmpty {
            ScrollView {
              LazyVStack(alignment: .leading, spacing: 10) {
                ForEach($userSettings.customizedLanguageColors) { $languageColor in
                  VStack(alignment: .leading, spacing: 8) {
                    Text(
                      workspaceData.getInputSourceLocalizedName(
                        inputSourceID: languageColor.inputSourceID)
                    )
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .if(languageColor.inputSourceID == workspaceData.currentInputSourceID) {
                      $0.foregroundColor(.accentColor)
                    }

                    HStack(alignment: .center, spacing: 10) {
                      Text(languageColor.inputSourceID)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                      Button(
                        role: .destructive,
                        action: {
                          userSettings.removeCustomizedLanguageColor(
                            languageColor.inputSourceID
                          )
                        },
                        label: {
                          Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                        }
                      )
                    }

                    colorRow(label: "Stripes") {
                      HStack(alignment: .center, spacing: 4) {
                        ColorPicker("stripe color 1", selection: $languageColor.colors.0)
                          .labelsHidden()

                        ColorPicker("stripe color 2", selection: $languageColor.colors.1)
                          .labelsHidden()

                        ColorPicker("stripe color 3", selection: $languageColor.colors.2)
                          .labelsHidden()
                      }
                    }

                    colorRow(label: "Pill") {
                      HStack(alignment: .center, spacing: 4) {
                        ColorPicker(
                          "Pill background",
                          selection: $languageColor.textPillBackgroundColor
                        )
                        .labelsHidden()

                        ColorPicker(
                          "Pill text",
                          selection: $languageColor.textPillForegroundColor
                        )
                        .labelsHidden()
                      }
                    }

                    colorRow(label: "Text") {
                      TextField("", text: $languageColor.textPillLabel)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 70)
                    }
                  }
                  .padding(.vertical, 6)

                  Divider()
                }
              }
              .padding(.trailing, 8)
            }
            .frame(height: 260)
          } else {
            Text(currentInputSourceLocalizedName)
              .foregroundColor(.gray)
          }

          Button(
            action: {
              userSettings.appendCustomizedLanguageColor(workspaceData.currentInputSourceID)
            },
            label: {
              Label(
                "Set the color for \(currentInputSourceLocalizedName)",
                systemImage: "plus")
            }
          ).disabled(
            userSettings.customizedLanguageColor(inputSourceID: workspaceData.currentInputSourceID)
              != nil
          )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }

  private func colorRow<Controls: View>(
    label: String,
    @ViewBuilder controls: () -> Controls
  ) -> some View {
    HStack(alignment: .center, spacing: 10) {
      Text(label)
        .font(.caption)
        .foregroundColor(.gray)
        .frame(width: 70, alignment: .leading)

      Spacer(minLength: 20)

      controls()
    }
  }
}
