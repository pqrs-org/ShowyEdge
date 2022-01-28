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

      let preferencesMenuItem = NSMenuItem(
        title: "Preferences...",
        action: #selector(showPreferences),
        keyEquivalent: "")
      preferencesMenuItem.target = self
      menu.addItem(preferencesMenuItem)

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

  @objc private func showPreferences(sender _: AnyObject?) {
    PreferencesWindowManager.shared.show()
  }
}
