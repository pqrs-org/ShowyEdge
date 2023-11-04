import SwiftUI

struct SettingsUpdateView: View {
  let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""

  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Updates")) {
        VStack(alignment: .leading) {
          Text("ShowyEdge version \(version)")

          HStack {
            CheckForUpdatesView()

            Spacer()

            CheckForBetaUpdatesView()
          }
        }.padding()
      }

      GroupBox(label: Text("Websites")) {
        HStack(spacing: 20.0) {
          Button(
            action: { NSWorkspace.shared.open(URL(string: "https://showyedge.pqrs.org")!) },
            label: {
              Label("Open official website", systemImage: "house")
            })
          Button(
            action: {
              NSWorkspace.shared.open(URL(string: "https://github.com/pqrs-org/ShowyEdge")!)
            },
            label: {
              Label("Open GitHub (source code)", systemImage: "network")
            })
          Spacer()
        }.padding()
      }

      Spacer()
    }.padding()
  }

  // This additional view is needed for the disabled state on the menu item to work properly before Monterey.
  // See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more information
  struct CheckForUpdatesView: View {
    @ObservedObject private var updater = Updater.shared

    var body: some View {
      Button(
        action: { updater.checkForUpdatesStableOnly() },
        label: {
          Label("Check for updates...", systemImage: "star")
        }
      )
      .disabled(!updater.canCheckForUpdates)
    }
  }

  // This additional view is needed for the disabled state on the menu item to work properly before Monterey.
  // See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more information
  struct CheckForBetaUpdatesView: View {
    @ObservedObject private var updater = Updater.shared

    var body: some View {
      Button(
        action: { updater.checkForUpdatesWithBetaVersion() },
        label: {
          Label("Check for beta updates...", systemImage: "star.circle")
        }
      )
      .disabled(!updater.canCheckForUpdates)
    }
  }
}

struct SettingsUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsUpdateView()
      .previewLayout(.sizeThatFits)
  }
}
