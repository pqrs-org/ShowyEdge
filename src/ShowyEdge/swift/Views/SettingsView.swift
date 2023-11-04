import SwiftUI

enum NavigationTag: String {
  case basic
  case indicator
  case customFrame
  case update
  case action
}

struct SettingsView: View {
  @State private var selection: NavigationTag = NavigationTag.basic

  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 0) {
          Group {
            Button(
              action: {
                selection = .basic
              },
              label: {
                SidebarLabelView(text: "Basic", systemImage: "gearshape")
              }
            )
            .sidebarButtonStyle(selected: selection == .basic)

            Button(
              action: {
                selection = .indicator
              },
              label: {
                SidebarLabelView(text: "Indicator", systemImage: "wrench")
              }
            )
            .sidebarButtonStyle(selected: selection == .indicator)

            Button(
              action: {
                selection = .customFrame
              },
              label: {
                SidebarLabelView(text: "Custom Frame", systemImage: "hammer")
              }
            )
            .sidebarButtonStyle(selected: selection == .customFrame)

            Button(
              action: {
                selection = .update
              },
              label: {
                SidebarLabelView(text: "Update", systemImage: "network")
              }
            )
            .sidebarButtonStyle(selected: selection == .update)
          }

          Divider()
            .padding(.vertical, 10.0)

          Group {
            Button(
              action: {
                selection = .action
              },
              label: {
                SidebarLabelView(text: "Quit, Restart", systemImage: "bolt.circle")
              }
            )
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
          SettingsCustomFrameView()
        case .update:
          SettingsUpdateView()
        case .action:
          SettingsActionView()
        }
      }
    }.frame(width: 900, height: 550)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .previewLayout(.sizeThatFits)
  }
}
