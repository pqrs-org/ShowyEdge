import Combine
import SettingsAccess
import SwiftUI

@main
struct ShowyEdgeApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  @StateObject private var userSettings: UserSettings
  // Since passing a property of an ObservableObject to MenuBarExtra.isInserted causes a notification loop, the flag must be an independent variable.
  @AppStorage("kShowIconInMenubar") var showMenuBarExtra: Bool = true

  private var cancellables = Set<AnyCancellable>()
  private let version =
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

  init() {
    //
    // Initialize properties
    //

    let userSettings = UserSettings()

    _userSettings = StateObject(wrappedValue: userSettings)

    appDelegate.userSettings = userSettings

    //
    // Register OpenAtLogin
    //

    if !OpenAtLogin.shared.developmentBinary {
      if !userSettings.initialOpenAtLoginRegistered {
        OpenAtLogin.shared.update(register: true)
        userSettings.initialOpenAtLoginRegistered = true
      }
    }

    //
    // Additional setups
    //

    NSApplication.shared.disableRelaunchOnLogin()

    WorkspaceData.shared.start()

    Updater.shared.checkForUpdatesInBackground()
  }

  var body: some Scene {
    // The main window is manually managed by MainWindowController.

    MenuBarExtra(
      isInserted: $showMenuBarExtra,
      content: {
        Text("ShowyEdge \(version)")

        Divider()

        SettingsLink {
          Label("Settings...", systemImage: "gearshape")
            .labelStyle(.titleAndIcon)
        } preAction: {
          NSApp.activate(ignoringOtherApps: true)
        } postAction: {
        }

        Button(
          action: {
            NSApp.activate(ignoringOtherApps: true)
            Updater.shared.checkForUpdatesStableOnly()
          },
          label: {
            Label("Check for updates...", systemImage: "network")
              .labelStyle(.titleAndIcon)
          }
        )

        if userSettings.showAdditionalMenuItems {
          Button(
            action: {
              NSApp.activate(ignoringOtherApps: true)
              Updater.shared.checkForUpdatesWithBetaVersion()
            },
            label: {
              Label("Check for beta updates...", systemImage: "hare")
                .labelStyle(.titleAndIcon)
            }
          )
        }

        Divider()

        Button(
          action: {
            NSApp.terminate(nil)
          },
          label: {
            Label("Quit ShowyEdge", systemImage: "xmark")
              .labelStyle(.titleAndIcon)
          }
        )
      },
      label: {
        Label(
          title: { Text("ShowyEdge") },
          icon: {
            // To prevent the menu icon from appearing blurry, it is necessary to explicitly set the displayScale.
            Image("menu")
              .environment(\.displayScale, 2.0)
          }
        )
      }
    )

    Settings {
      SettingsView(showMenuBarExtra: $showMenuBarExtra)
        .environmentObject(userSettings)
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var indicatorsController: IndicatorsController?
  var userSettings: UserSettings?

  func applicationDidFinishLaunching(_ notification: Notification) {
    guard let userSettings = userSettings else { return }

    indicatorsController = IndicatorsController(userSettings: userSettings)
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
  {
    NotificationCenter.default.post(
      name: openSettingsNotification,
      object: nil,
      userInfo: nil)
    return true
  }
}
