import SwiftUI

struct PreferencesView: View {
  @State private var selection: String? = "Basic"

  let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

  var body: some View {
    let padding = 6.0

    NavigationView {
      List {
        NavigationLink(
          destination: PreferencesBasicView(),
          tag: "Basic",
          selection: $selection
        ) {
          Label("Basic", systemImage: "gearshape")
        }
        .padding(padding)

        NavigationLink(
          destination: PreferencesIndicatorView(),
          tag: "Indicator",
          selection: $selection
        ) {
          Label("Indicator", systemImage: "wrench")
        }
        .padding(padding)

        NavigationLink(
          destination: PreferencesCustomFrameView(),
          tag: "Custom Frame",
          selection: $selection
        ) {
          Label("Custom Frame", systemImage: "hammer")
        }
        .padding(padding)

        NavigationLink(
          destination: PreferencesMiscView(),
          tag: "Misc",
          selection: $selection
        ) {
          Label("Misc", systemImage: "cube")
        }
        .padding(padding)

        Divider()

        NavigationLink(
          destination: PreferencesActionView(),
          tag: "Action",
          selection: $selection
        ) {
          Label("Quit, Restart", systemImage: "bolt.circle")
        }
        .padding(padding)
      }
      .listStyle(SidebarListStyle())
      .frame(width: 200)
    }.frame(width: 900, height: 550)
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferencesView()
      .previewLayout(.sizeThatFits)
  }
}
