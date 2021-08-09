import SwiftUI

struct PreferencesBasicView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack {
            Text("Basic View")
        }
    }
}

struct PreferencesBasicView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesBasicView()
            .previewLayout(.sizeThatFits)
    }
}
