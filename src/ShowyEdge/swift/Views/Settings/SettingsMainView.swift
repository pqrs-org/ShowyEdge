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
            .foregroundColor(Color.errorForeground)
            .background(Color.errorBackground)
          }

          Toggle(isOn: $showMenuBarExtra) {
            Text("Show icon in menu bar")
          }
          .switchToggleStyle()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      let currentInputSourceLocalizedName = workspaceData.getInputSourceLocalizedName(
        inputSourceID: workspaceData.currentInputSourceID)

      GroupBox(label: Text("Color")) {
        VStack(alignment: .leading, spacing: 10.0) {
          ScrollView {
            if $userSettings.customizedLanguageColors.count > 0 {
              Grid(alignment: .leading) {
                ForEach($userSettings.customizedLanguageColors) { $languageColor in
                  GridRow {
                    VStack {
                      Text(
                        workspaceData.getInputSourceLocalizedName(
                          inputSourceID: languageColor.inputSourceID)
                      )
                      .fixedSize(horizontal: false, vertical: true)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .if(languageColor.inputSourceID == workspaceData.currentInputSourceID) {
                        $0.foregroundColor(.accentColor)
                      }

                      Text(languageColor.inputSourceID)
                        .font(.caption)
                        .padding(.leading, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    ColorPicker("color 1", selection: $languageColor.colors.0)
                      .labelsHidden()

                    ColorPicker("color 2", selection: $languageColor.colors.1)
                      .labelsHidden()

                    ColorPicker("color 3", selection: $languageColor.colors.2)
                      .labelsHidden()

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
                    .padding(.leading, 20)
                  }
                }
              }
            } else {
              Text(currentInputSourceLocalizedName)
                .foregroundColor(.gray)
            }
          }
          .frame(height: 200)

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
}
