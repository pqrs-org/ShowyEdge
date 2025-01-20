import SwiftUI

enum TabTag: String {
  case main
  case indicator
  case customFrame
  case update
  case action
}

struct SettingsView: View {
  @Binding var showMenuBarExtra: Bool

  @State private var selection = TabTag.main

  var body: some View {
    TabView(selection: $selection) {
      SettingsMainView(showMenuBarExtra: $showMenuBarExtra)
        .tabItem {
          Label("Main", systemImage: "gearshape")
        }
        .tag(TabTag.main)

      SettingsIndicatorView()
        .tabItem {
          Label("Indicator", systemImage: "wrench")
        }
        .tag(TabTag.indicator)

      SettingsCustomFrameView()
        .tabItem {
          Label("Custom Frame", systemImage: "rectangle.3.group")
        }
        .tag(TabTag.customFrame)

      SettingsUpdateView()
        .tabItem {
          Label("Update", systemImage: "network")
        }
        .tag(TabTag.update)

      SettingsActionView()
        .tabItem {
          Label("Quit, Restart", systemImage: "xmark")
        }
        .tag(TabTag.action)
    }
    .scenePadding()
    .frame(width: 600)
  }
}
