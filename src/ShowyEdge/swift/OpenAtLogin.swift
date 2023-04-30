import Foundation
import ServiceManagement

final class OpenAtLogin: ObservableObject {
  static let shared = OpenAtLogin()
  var error = ""

  func registerLauncher(enabled: Bool) {
    let launcherBundleIdentifier = "org.pqrs.ShowyEdge.Launcher"

    error = ""

    if #available(macOS 13.0, *) {
      do {
        let service = SMAppService.loginItem(identifier: launcherBundleIdentifier)
        if enabled {
          try service.register()
        } else {
          try service.unregister()
        }
      } catch {
        self.error = error.localizedDescription
      }
    } else {
      let result = SMLoginItemSetEnabled(launcherBundleIdentifier as CFString, enabled)
      if !result {
        error = "SMLoginItemSetEnabled error"
      }
    }
  }
}
