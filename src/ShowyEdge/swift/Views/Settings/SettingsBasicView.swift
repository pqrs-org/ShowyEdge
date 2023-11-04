import SwiftUI

struct SettingsBasicView: View {
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
            Toggle(isOn: $userSettings.showMenu) {
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
          List($userSettings.customizedLanguageColors) { $languageColor in
            VStack(spacing: 4) {
              VStack(spacing: 4) {
                HStack(spacing: 0) {
                  Text(languageColor.inputSourceID)
                    .truncationMode(.tail)
                    .lineLimit(1)

                  Spacer()

                  Button(
                    action: {
                      userSettings.removeCustomizedLanguageColor(
                        languageColor.inputSourceID
                      )
                    },
                    label: {
                      Label("Delete", systemImage: "xmark")
                    })
                }

                HStack(spacing: 0) {
                  ColorPicker("color 1", selection: $languageColor.colors.0)
                    .frame(width: 60)
                    .labelsHidden()

                  ColorPicker("color 2", selection: $languageColor.colors.1)
                    .frame(width: 60)
                    .labelsHidden()

                  ColorPicker("color 3", selection: $languageColor.colors.2)
                    .frame(width: 60)
                    .labelsHidden()

                  Spacer()
                }
                .padding(.leading, 20.0)
              }
              .padding(10)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(
                    Color(NSColor.selectedControlColor),
                    lineWidth: languageColor.inputSourceID == workspaceData.currentInputSourceID
                      ? 3 : 0
                  )
                  .padding(2)
              )

              Divider()
            }
          }

          Button(
            action: {
              userSettings.appendCustomizedLanguageColor(workspaceData.currentInputSourceID)
            },
            label: {
              Label(
                "Add custom color of \(workspaceData.currentInputSourceID)", systemImage: "plus")
            }
          ).disabled(
            userSettings.customizedLanguageColor(inputSourceID: workspaceData.currentInputSourceID)
              != nil
          )
        }.padding()
      }
    }.padding()
  }
}

struct SettingsBasicView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsBasicView()
      .previewLayout(.sizeThatFits)
  }
}
