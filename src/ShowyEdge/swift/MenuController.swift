import AppKit

class MenuController: NSObject {
  static let shared = MenuController()
  var statusItem: NSStatusItem?

  public func show() {
    if statusItem == nil {
      statusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.squareLength
      )

      statusItem?.button?.image = NSImage(named: "menu")

      let menu = NSMenu(title: "ShowyEdge")

      let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
      menu.addItem(withTitle: "ShowyEdge \(version)", action: nil, keyEquivalent: "")

      menu.addItem(NSMenuItem.separator())

      let settingsMenuItem = NSMenuItem(
        title: "Settings...",
        action: #selector(showSettings),
        keyEquivalent: "")
      settingsMenuItem.target = self
      menu.addItem(settingsMenuItem)

      menu.addItem(NSMenuItem.separator())

      menu.addItem(
        withTitle: "Quit ShowyEdge",
        action: #selector(NSApplication.shared.terminate),
        keyEquivalent: ""
      )

      statusItem?.menu = menu
    }

    //
    // Set visibility
    //

    statusItem?.isVisible = UserSettings.shared.showMenu
  }

  @objc private func showSettings(sender _: AnyObject?) {
    SettingsWindowManager.shared.show()
  }
}
