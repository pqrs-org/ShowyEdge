import SwiftUI

struct SettingsMainView: View {
  @Binding var showMenuBarExtra: Bool

  @EnvironmentObject private var userSettings: UserSettings
  @ObservedObject private var openAtLogin = OpenAtLogin.shared
  @ObservedObject private var workspaceData = WorkspaceData.shared

  @State private var hoverLanguageColor: LanguageColor?

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
          if $userSettings.customizedLanguageColors.count > 0 {
            ScrollViewReader { proxy in
              List {
                ForEach($userSettings.customizedLanguageColors) { $languageColor in
                  // Make a copy to use it in onHover.
                  // (Without copy, the program crashes with an incorrect reference when the profile is deleted.)
                  let languageColorCopy = languageColor

                  VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 4) {
                      Text(
                        workspaceData.getInputSourceLocalizedName(
                          inputSourceID: languageColor.inputSourceID)
                      )
                      .padding(.trailing, 2)
                      .fixedSize(horizontal: false, vertical: true)
                      .if(languageColor.inputSourceID == workspaceData.currentInputSourceID) {
                        $0.foregroundColor(.accentColor)
                      }
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .if(hoverLanguageColor == languageColorCopy) {
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
                        .padding(.leading, 10)
                      }
                      .padding(.leading, 10)
                      .onHover { hovering in
                        if hovering {
                          hoverLanguageColor = languageColorCopy
                        } else {
                          if hoverLanguageColor == languageColorCopy {
                            hoverLanguageColor = nil
                          }
                        }
                      }
                    }

                    Text(languageColor.inputSourceID)
                      .font(.caption)
                      .fixedSize(horizontal: false, vertical: true)
                  }
                }
              }
              .frame(height: 200)
              .onChange(of: userSettings.customizedLanguageColors.count) { _ in
                if let first = userSettings.customizedLanguageColors.first {
                  withAnimation {
                    // Reset position when customizedLanguageColors is added.
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
