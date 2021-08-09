import SwiftUI

struct PreferencesMiscView: View {
    @ObservedObject var userSettings = UserSettings.shared

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            #if USE_SPARKLE
                GroupBox(label: Text("Updates")) {
                    VStack(alignment: .leading) {
                        Text("ShowyEdge version \(version)")
                        
                    HStack {
                        Button(action: { Updater.checkForUpdatesStableOnly() }) {
                            Image(decorative: "ic_star_18pt")
                                .resizable()
                                .frame(width: GUISize.buttonIconWidth, height: GUISize.buttonIconHeight)
                            Text("Check for updates")
                        }

                        Spacer()

                        Button(action: { Updater.checkForUpdatesWithBetaVersion() }) {
                            Image(decorative: "ic_star_18pt")
                                .resizable()
                                .frame(width: GUISize.buttonIconWidth, height: GUISize.buttonIconHeight)
                            Text("Check for beta updates")
                        }
                    }
                    }.padding()
                }
            #endif

            GroupBox(label: Text("Web sites")) {
                HStack(spacing: 20.0) {
                    Button(action: { NSWorkspace.shared.open(URL(string: "https://showyedge.pqrs.org")!) }) {
                        Image(decorative: "ic_home_18pt")
                            .resizable()
                            .frame(width: GUISize.buttonIconWidth, height: GUISize.buttonIconHeight)
                        Text("Open official website")
                    }
                    Button(action: { NSWorkspace.shared.open(URL(string: "https://github.com/pqrs-org/ShowyEdge")!) }) {
                        Image(decorative: "ic_code_18pt")
                            .resizable()
                            .frame(width: GUISize.buttonIconWidth, height: GUISize.buttonIconHeight)
                        Text("Open GitHub (source code)")
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
