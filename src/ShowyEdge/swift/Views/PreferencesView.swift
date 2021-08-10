import SwiftUI

struct PreferencesView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @State private var shouldShowBasic = true

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: PreferencesBasicView(),
                                   isActive: $shouldShowBasic) {
                        Label("Basic", systemImage: "gearshape")
                    }
                    .padding(10.0)

                    NavigationLink(destination: PreferencesIndicatorView()) {
                        Label("Indicator", systemImage: "wrench")
                    }
                        .padding(10.0)

                    NavigationLink(destination: PreferencesCustomFrameView()) {
                        Label("Custom Frame", systemImage: "hammer")
                    }
                        .padding(10.0)

                    NavigationLink(destination: PreferencesMiscView()) {
                        Label("Misc", systemImage: "cube")
                    }
                        .padding(10.0)

                    Spacer()
                }
                .listStyle(SidebarListStyle())
                .frame(width: 200)
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
