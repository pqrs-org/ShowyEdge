import SwiftUI

struct PreferencesMiscView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack {
            Text("Misc View")
        }
    }
}

struct PreferencesMiscView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesBasicView()
            .previewLayout(.sizeThatFits)
    }
}
