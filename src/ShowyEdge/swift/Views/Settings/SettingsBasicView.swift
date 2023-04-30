import SwiftUI

struct SettingsBasicView: View {
  @ObservedObject var userSettings = UserSettings.shared
  @ObservedObject var workspaceData = WorkspaceData.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Basic")) {
        VStack(alignment: .leading, spacing: 10.0) {
          HStack {
            Toggle(isOn: $userSettings.openAtLogin) {
              Text("Open at login")
            }
            .switchToggleStyle()

            Spacer()
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
              HStack(spacing: 0) {
                Text(languageColor.inputSourceID)
                  .truncationMode(.tail)
                  .lineLimit(1)

                Spacer()

                Button(action: {
                  userSettings.removeCustomizedLanguageColor(
                    languageColor.inputSourceID
                  )
                }) {
                  Label("Delete", systemImage: "xmark")
                }
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
          }
          .listRowInsets(.init())

          Button(action: {
            userSettings.appendCustomizedLanguageColor(workspaceData.currentInputSourceID)
          }) {
            Label("Add custom color of \(workspaceData.currentInputSourceID)", systemImage: "plus")
          }.disabled(
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
