import SwiftUI

struct PreferencesBasicView: View {
    @ObservedObject var userSettings = UserSettings.shared

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
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(userSettings.customizedLanguageColors.indices, id: \.self) { index in
                            HStack(spacing: 0) {
                                Text(userSettings.customizedLanguageColors[index].inputSourceID)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                ColorPicker("", selection: $userSettings.customizedLanguageColors[index].colors.0)
                                ColorPicker("", selection: $userSettings.customizedLanguageColors[index].colors.1)
                                ColorPicker("", selection: $userSettings.customizedLanguageColors[index].colors.2)

                                Button(action: { Updater.checkForUpdatesStableOnly() }) {
                                    Label("Delete", systemImage: "xmark")
                                }
                                .padding(.leading, 20.0)
                            }.padding(0)

                            if index < userSettings.customizedLanguageColors.indices.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
            }

            Spacer()
        }.padding()
    }
}

struct PreferencesBasicView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesBasicView()
            .previewLayout(.sizeThatFits)
    }
}
