import AppKit
import Foundation

struct Relauncher {
  static func relaunch() {
    print("relaunch")

    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true

    NSWorkspace.shared.openApplication(
      at: Bundle.main.bundleURL,
      configuration: configuration
    ) { _, error in
      if error == nil {
        DispatchQueue.main.async {
          NSApplication.shared.terminate(self)
        }
      }
    }
  }
}
