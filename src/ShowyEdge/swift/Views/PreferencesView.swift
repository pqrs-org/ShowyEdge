import SwiftUI

struct PreferencesView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @State private var selection: String? = "Basic"

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack {
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    List {
                        NavigationLink(destination: PreferencesBasicView(),
                                       tag: "Basic",
                                       selection: $selection) {
                            Label("Basic", systemImage: "gearshape")
                        }
                        .padding(10)

                        NavigationLink(destination: PreferencesIndicatorView(),
                                       tag: "Indicator",
                                       selection: $selection) {
                            Label("Indicator", systemImage: "wrench")
                        }
                        .padding(10)

                        NavigationLink(destination: PreferencesCustomFrameView(),
                                       tag: "Custom Frame",
                                       selection: $selection) {
                            Label("Custom Frame", systemImage: "hammer")
                        }
                        .padding(10)

                        NavigationLink(destination: PreferencesMiscView(),
                                       tag: "Misc",
                                       selection: $selection) {
                            Label("Misc", systemImage: "cube")
                        }
                        .padding(10)
                    }
                    .listStyle(SidebarListStyle())
                    .frame(width: 200)

                    Spacer()
                    Divider()

                    VStack {
                        Button(action: { NSApplication.shared.terminate(self) }) {
                            Label("Quit ShowyEdge", systemImage: "xmark.circle.fill")
                        }
                    }
                    .padding(10)
                }
            }
        }.frame(width: 900, height: 550)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .previewLayout(.sizeThatFits)
    }
}
