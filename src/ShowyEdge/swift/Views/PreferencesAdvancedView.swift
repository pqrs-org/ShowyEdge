import SwiftUI

struct PreferencesAdvancedView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack {
            Text("Advanced View")
        }
    }
}

struct PreferencesAdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesAdvancedView()
            .previewLayout(.sizeThatFits)
    }
}
