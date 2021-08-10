import SwiftUI

struct PreferencesMiscView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            #if USE_SPARKLE
                GroupBox(label: Text("Updates")) {
                    VStack(alignment: .leading) {
                        Text("ShowyEdge version \(version)")

                    HStack {
                        Button(action: { Updater.checkForUpdatesStableOnly() }) {
                            Label("Check for updates", systemImage: "star")
                        }

                        Spacer()

                        Button(action: { Updater.checkForUpdatesWithBetaVersion() }) {
                            Label("Check for beta updates", systemImage: "star.circle")
                        }
                    }
                    }.padding()
                }
            #endif

            GroupBox(label: Text("Web sites")) {
                HStack(spacing: 20.0) {
                    Button(action: { NSWorkspace.shared.open(URL(string: "https://showyedge.pqrs.org")!) }) {
                        Label("Open official website", systemImage: "house")
                    }
                    Button(action: { NSWorkspace.shared.open(URL(string: "https://github.com/pqrs-org/ShowyEdge")!) }) {
                        Label("Open GitHub (source code)", systemImage: "network")
                    }
                    Spacer()
                }.padding()
            }

            Spacer()
        }.padding()
    }
}

struct PreferencesMiscView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesMiscView()
            .previewLayout(.sizeThatFits)
    }
}
