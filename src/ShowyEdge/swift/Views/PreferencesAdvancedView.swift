import SwiftUI

struct PreferencesAdvancedView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            GroupBox(label: Text("Opacity")) {
                VStack {
                    Slider(
                        value: $userSettings.indicatorOpacity,
                        in: 0 ... 100,
                        step: 5,
                        minimumValueLabel: Text("Clear"),
                        maximumValueLabel: Text("Colored (Default)"),
                        label: {
                            Text("")
                        }
                    )
                }.padding()
            }
            Spacer()
        }.padding()
    }
}

struct PreferencesAdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesAdvancedView()
            .previewLayout(.sizeThatFits)
    }
}
