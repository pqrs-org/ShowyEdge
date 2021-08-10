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
                        .padding(10.0)

                    NavigationLink("Indicator",
                                   destination: PreferencesIndicatorView())
                        .padding(10.0)

                    NavigationLink("Custom Frame",
                                   destination: PreferencesCustomFrameView())
                        .padding(10.0)

                    NavigationLink("Misc",
                                   destination: PreferencesMiscView())
                        .padding(10.0)

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
