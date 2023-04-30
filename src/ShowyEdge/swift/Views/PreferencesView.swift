import SwiftUI

enum NavigationTag: String {
  case basic
  case indicator
  case customFrame
  case misc
  case action
}

struct PreferencesView: View {
  @State private var selection: NavigationTag = NavigationTag.basic

  let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 0) {
          Group {
            Button(action: {
              selection = .basic
            }) {
              SidebarLabelView(text: "Basic", systemImage: "gearshape")
            }
            .sidebarButtonStyle(selected: selection == .basic)

            Button(action: {
              selection = .indicator
            }) {
              SidebarLabelView(text: "Indicator", systemImage: "wrench")
            }
            .sidebarButtonStyle(selected: selection == .indicator)

            Button(action: {
              selection = .customFrame
            }) {
              SidebarLabelView(text: "Custom Frame", systemImage: "hammer")
            }
            .sidebarButtonStyle(selected: selection == .customFrame)

            Button(action: {
              selection = .misc
            }) {
              SidebarLabelView(text: "Misc", systemImage: "cube")
            }
            .sidebarButtonStyle(selected: selection == .misc)
          }

          Divider()
            .padding(.vertical, 10.0)

          Group {
            Button(action: {
              selection = .action
            }) {
              SidebarLabelView(text: "Quit, Restart", systemImage: "bolt.circle")
            }
            .sidebarButtonStyle(selected: selection == .action)
          }

          Spacer()
        }
        .frame(width: 200)

        Divider()

        switch selection {
        case .basic:
          SettingsBasicView()
        case .indicator:
          SettingsIndicatorView()
        case .customFrame:
          PreferencesCustomFrameView()
        case .misc:
          PreferencesMiscView()
        case .action:
          PreferencesActionView()
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
