import SwiftUI

struct PreferencesView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @State private var shouldShowBasic = true

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink("Basic",
                                   destination: PreferencesBasicView(),
                                   isActive: $shouldShowBasic)
                    NavigationLink("Indicator",
                                   destination: PreferencesIndicatorView())
                    NavigationLink("Custom Frame",
                                   destination: PreferencesCustomFrameView())
                    NavigationLink("Misc",
                                   destination: PreferencesMiscView())
                    Spacer()
                }
                .listStyle(SidebarListStyle())
                .frame(width: 160)
            }
        }.frame(width: 800.0, height: 500.0)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .previewLayout(.sizeThatFits)
    }
}
