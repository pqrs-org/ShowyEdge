import SwiftUI

enum TabTag: String {
  case main
  case indicator
  case textPill
  case followActiveWindow
  case customFrame
  case update
  case action
}

struct SettingsView: View {
  @Binding var showMenuBarExtra: Bool

  @EnvironmentObject private var userSettings: UserSettings

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

      SettingsFollowActiveWindowView()
        .tabItem {
          Label("Follow", systemImage: "scope")
        }
        .tag(TabTag.followActiveWindow)

      if userSettings.indicatorDisplayMode == IndicatorDisplayMode.colors.rawValue {
        SettingsCustomFrameView()
          .tabItem {
            Label("Frame", systemImage: "rectangle.3.group")
          }
          .tag(TabTag.customFrame)
      }

      if userSettings.indicatorDisplayMode == IndicatorDisplayMode.textPill.rawValue {
        SettingsTextPillView()
          .tabItem {
            Label("Text Pill", systemImage: "character.textbox")
          }
          .tag(TabTag.textPill)
      }

      SettingsUpdateView()
        .tabItem {
          Label("Update", systemImage: "network")
        }
        .tag(TabTag.update)

      SettingsActionView()
        .tabItem {
          Label("Quit, Restart", systemImage: "xmark.rectangle")
        }
        .tag(TabTag.action)
    }
    .scenePadding()
    .frame(width: 600)
    .onChange(of: userSettings.indicatorDisplayMode) { _ in
      switch selection {
      case .customFrame
      where userSettings.indicatorDisplayMode != IndicatorDisplayMode.colors.rawValue,
        .textPill
      where userSettings.indicatorDisplayMode != IndicatorDisplayMode.textPill.rawValue:
        selection = .indicator
      default:
        break
      }
    }
  }
}
