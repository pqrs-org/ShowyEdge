import SwiftUI

struct PreferencesBasicView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            GroupBox(label: Text("Basic")) {
                VStack(alignment: .leading, spacing: 10.0) {
                    Toggle(isOn: $userSettings.openAtLogin) {
                        Text("Open at login)")
                        Spacer()
                    }

                    Toggle(isOn: $userSettings.showMenu) {
                        Text("Show icon in menu bar")
                        Spacer()
                    }
                }

                .padding()
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
