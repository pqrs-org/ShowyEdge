import SwiftUI

struct PreferencesBasicView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @ObservedObject var workspaceData = WorkspaceData.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            GroupBox(label: Text("Basic")) {
                VStack(alignment: .leading, spacing: 10.0) {
                    Toggle(isOn: $userSettings.openAtLogin) {
                        Text("Open at login")
                        Spacer()
                    }

                    Toggle(isOn: $userSettings.showMenu) {
                        Text("Show icon in menu bar")
                        Spacer()
                    }
                }
                .padding()
            }

            GroupBox(label: Text("Color")) {
                VStack(alignment: .leading, spacing: 10.0) {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach($userSettings.customizedLanguageColors) { $languageColor in
                                HStack(spacing: 0) {
                                    Text(languageColor.inputSourceID)
                                        .truncationMode(.tail)
                                        .lineLimit(1)

                                    Spacer()

                                    ColorPicker("", selection: $languageColor.colors.0)
                                    ColorPicker("", selection: $languageColor.colors.1)
                                    ColorPicker("", selection: $languageColor.colors.2)

                                    Button(action: {
                                        userSettings.removeCustomizedLanguageColor(
                                            languageColor.inputSourceID
                                        )
                                    }) {
                                        Label("Delete", systemImage: "xmark")
                                    }
                                    .padding(.leading, 20.0)
                                }.padding(0)

                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)

                    Button(action: {
                        userSettings.appendCustomizedLanguageColor(workspaceData.currentInputSourceID)
                    }) {
                        Label("Add custom color of \(workspaceData.currentInputSourceID)", systemImage: "plus")
                    }
                }.padding()
            }
        }.padding()
    }
}

struct PreferencesBasicView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesBasicView()
            .previewLayout(.sizeThatFits)
    }
}
