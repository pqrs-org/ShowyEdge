import SwiftUI

struct SettingsMainView: View {
  @Binding var showMenuBarExtra: Bool

  @ObservedObject private var userSettings = UserSettings.shared
  @ObservedObject private var openAtLogin = OpenAtLogin.shared
  @ObservedObject private var workspaceData = WorkspaceData.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Basic")) {
        VStack(alignment: .leading, spacing: 10.0) {
          HStack {
            Toggle(isOn: $openAtLogin.registered) {
              Text("Open at login")
            }
            .switchToggleStyle()
            .disabled(openAtLogin.developmentBinary)
            .onChange(of: openAtLogin.registered) { value in
              OpenAtLogin.shared.update(register: value)
            }

            Spacer()
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

          HStack {
            Toggle(isOn: $showMenuBarExtra) {
              Text("Show icon in menu bar")
            }
            .switchToggleStyle()

            Spacer()
          }
        }
        .padding()
      }

      GroupBox(label: Text("Color")) {
        VStack(alignment: .leading, spacing: 10.0) {
          ScrollView {
            Grid(alignment: .leading) {
              ForEach($userSettings.customizedLanguageColors) { $languageColor in
                GridRow {
                  Text(languageColor.inputSourceID)
                    .fixedSize(horizontal: false, vertical: true)
                    .if(languageColor.inputSourceID == workspaceData.currentInputSourceID) {
                      $0.foregroundColor(.accentColor)
                    }

                  ColorPicker("color 1", selection: $languageColor.colors.0)
                    //.frame(width: 50)
                    .labelsHidden()

                  ColorPicker("color 2", selection: $languageColor.colors.1)
                    //.frame(width: 50)
                    .labelsHidden()

                  ColorPicker("color 3", selection: $languageColor.colors.2)
                    //.frame(width: 50)
                    .labelsHidden()

                  Spacer()

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
              }
            }
          }
          .frame(height: 200)

          Button(
            action: {
              userSettings.appendCustomizedLanguageColor(workspaceData.currentInputSourceID)
            },
            label: {
              Label(
                "Add \(workspaceData.currentInputSourceID)", systemImage: "plus")
            }
          ).disabled(
            userSettings.customizedLanguageColor(inputSourceID: workspaceData.currentInputSourceID)
              != nil
          )
        }.padding()
      }
    }
  }
}
