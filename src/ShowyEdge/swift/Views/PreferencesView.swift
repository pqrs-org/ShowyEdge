import SwiftUI

struct PreferencesView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @State private var selection: String? = "Basic"

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: PreferencesBasicView(),
                                   tag: "Basic",
                                   selection: $selection) {
                        Label("Basic", systemImage: "gearshape")
                    }
                    .padding(10.0)

                    NavigationLink(destination: PreferencesIndicatorView(),
                                   tag: "Indicator",
                                   selection: $selection) {
                        Label("Indicator", systemImage: "wrench")
                    }
                    .padding(10.0)

                    NavigationLink(destination: PreferencesCustomFrameView(),
                                   tag: "Custom Frame",
                                   selection: $selection) {
                        Label("Custom Frame", systemImage: "hammer")
                    }
                    .padding(10.0)

                    NavigationLink(destination: PreferencesMiscView(),
                                   tag: "Misc",
                                   selection: $selection) {
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
