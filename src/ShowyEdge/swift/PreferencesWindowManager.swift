import SwiftUI

class PreferencesWindowManager: NSObject {
  static let shared = PreferencesWindowManager()

  private var preferencesWindow: NSWindow?
  private var closed = false

  func show() {
    if preferencesWindow != nil, !closed {
      preferencesWindow!.makeKeyAndOrderFront(self)
      NSApp.activate(ignoringOtherApps: true)
      return
    }

    closed = false

    preferencesWindow = NSWindow(
      contentRect: .zero,
      styleMask: [
        .titled,
        .closable,
        .miniaturizable,
        .fullSizeContentView,
      ],
      backing: .buffered,
      defer: false
    )

    preferencesWindow!.isReleasedWhenClosed = false
    preferencesWindow!.title = "ShowyEdge Preferences"
    preferencesWindow!.contentView = NSHostingView(rootView: SettingsView())
    preferencesWindow!.delegate = self
    preferencesWindow!.center()

    preferencesWindow!.makeKeyAndOrderFront(self)
    NSApp.activate(ignoringOtherApps: true)
  }
}

extension PreferencesWindowManager: NSWindowDelegate {
  func windowWillClose(_: Notification) {
    closed = true
  }
}
