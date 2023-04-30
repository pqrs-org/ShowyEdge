import AppKit

public class AppDelegate: NSObject, NSApplicationDelegate {
  public func applicationDidFinishLaunching(_: Notification) {
    NSApplication.shared.disableRelaunchOnLogin()

    let mainApplicationBundleIdentifier = "org.pqrs.ShowyEdge"

    let isRunning = NSWorkspace.shared.runningApplications.contains {
      $0.bundleIdentifier == mainApplicationBundleIdentifier
    }

    if !isRunning {
      if let url = NSWorkspace.shared.urlForApplication(
        withBundleIdentifier: mainApplicationBundleIdentifier)
      {
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.openApplication(at: url, configuration: configuration) { _, _ in
          DispatchQueue.main.async {
            // NSApplication.shared.terminate must be called in the UI thread.
            NSApplication.shared.terminate(self)
          }
        }

        return
      }
    }

    NSApplication.shared.terminate(self)
  }
}
