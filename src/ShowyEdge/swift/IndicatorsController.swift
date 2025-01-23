import Combine
import SettingsAccess
import SwiftUI

class IndicatorsController {
  private var userSettings: UserSettings

  private var windows: [NSWindow] = []
  private var cancellables = Set<AnyCancellable>()

  init(userSettings: UserSettings) {
    self.userSettings = userSettings

    NotificationCenter.default.addObserver(
      forName: NSApplication.didChangeScreenParametersNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }

      self.updateWindowFrames()
    }

    NotificationCenter.default.addObserver(
      forName: WorkspaceData.fullScreenModeChanged,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }

      self.updateWindowFrames()
    }

    NotificationCenter.default.addObserver(
      forName: WorkspaceData.currentInputSourceChanged,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }

      self.updateWindowFrames()
      self.updateColorByInputSource()
    }

    userSettings.objectWillChange.sink { _ in
      self.updateWindowFrames()
      self.updateColorByInputSource()
    }.store(in: &cancellables)

    setupWindows()
    updateWindowFrames()
    updateColorByInputSource()
  }

  private func setupWindows() {
    let screens = NSScreen.screens

    //
    // Create window if needed
    //

    while windows.count < screens.count {
      // Note:
      // On macOS 13, the only way to remove the title bar is to manually create an NSWindow like this.
      //
      // The following methods do not work properly:
      // - .windowStyle(.hiddenTitleBar) does not remove the window frame.
      // - NSApp.windows.first.styleMask = [.borderless] causes the app to crash.

      let w = NSWindow(
        contentRect: .zero,
        styleMask: [
          .borderless
        ],
        backing: .buffered,
        defer: false
      )

      // Note: Do not set alpha value for window.
      // Window with alpha value causes glitch at switching a space (Mission Control).

      w.backgroundColor = .clear
      w.isOpaque = false
      w.hasShadow = false
      w.ignoresMouseEvents = true
      w.collectionBehavior.insert(.canJoinAllSpaces)
      w.collectionBehavior.insert(.ignoresCycle)
      w.collectionBehavior.insert(.stationary)
      w.contentView = NSHostingView(
        rootView: IndicatorView(userSettings: userSettings)
          .openSettingsAccess()
      )

      windows.append(w)
    }

    //
    // Update window level
    //

    windows.forEach { w in
      if userSettings.showIndicatorBehindAppWindows {
        w.level = .normal
      } else {
        w.level = .statusBar
      }
    }
  }

  private func updateWindowFrames() {
    setupWindows()

    // ----------------------------------------
    let screens = NSScreen.screens
    var firstScreenFrame = NSRect.zero
    if screens.count > 0 {
      firstScreenFrame = screens[0].frame
    }

    for (i, w) in windows.enumerated() {
      var screenFrame = NSRect.zero
      if i < screens.count {
        screenFrame = screens[i].frame
      }

      let menuOriginX = screenFrame.origin.x
      let menuOriginY = firstScreenFrame.size.height - screenFrame.maxY

      let isFullScreenSpace = !WorkspaceData.shared.menubarOrigins.contains(
        CGPoint(
          x: menuOriginX,
          y: menuOriginY))

      var hide = false
      if i >= screens.count {
        hide = true
      } else if userSettings.hideInFullScreenSpace,
        isFullScreenSpace
      {
        hide = true
      } else if userSettings.showIndicatorBehindAppWindows,
        isFullScreenSpace
      {
        // Hide indicator in full screen space if `Show indicator behind app windows` option is enabled.
        hide = true
      }

      if hide {
        w.orderOut(self)

      } else {
        var rect = screens[i].frame

        if userSettings.useCustomFrame {
          let fullWidth = rect.size.width
          let fullHeight = rect.size.height

          //
          // Size
          //

          var width = CGFloat(userSettings.customFrameWidth)
          var height = CGFloat(userSettings.customFrameHeight)

          if userSettings.customFrameWidthUnit == CustomFrameUnit.percent.rawValue {
            if width > 100 {
              width = 100
            }
            width = fullWidth * (width / 100)
          }

          if userSettings.customFrameHeightUnit == CustomFrameUnit.percent.rawValue {
            if height > 100 {
              height = 100
            }
            height = fullHeight * (height / 100)
          }

          if width < 1.0 {
            width = 1.0
          }
          if height < 1.0 {
            height = 1.0
          }

          //
          // Origin
          //

          var top = CGFloat(userSettings.customFrameTop)
          var left = CGFloat(userSettings.customFrameLeft)

          if userSettings.customFrameOrigin == CustomFrameOrigin.upperLeft.rawValue
            || userSettings.customFrameOrigin == CustomFrameOrigin.upperRight.rawValue
          {
            top = fullHeight - top - height
          }

          if userSettings.customFrameOrigin == CustomFrameOrigin.upperRight.rawValue
            || userSettings.customFrameOrigin == CustomFrameOrigin.lowerRight.rawValue
          {
            left = fullWidth - left - width
          }

          rect.origin.x += left
          rect.origin.y += top
          rect.size.width = width
          rect.size.height = height

          w.setFrame(rect, display: false)

        } else {
          let width = rect.size.width
          var height = CGFloat(userSettings.indicatorHeightPx)
          if height > rect.size.height {
            height = rect.size.height
          }

          // To avoid top 1px gap, we need to add an adjust value to frame.size.height.
          // (Do not add an adjust value to frame.origin.y.)
          //
          // origin.y + size.height +-------------------------------------------+
          //                        |                                           |
          //               origin.y +-------------------------------------------+
          //                        origin.x                                    origin.x + size.width
          //

          rect.origin.x += 0
          rect.origin.y += rect.size.height - height
          rect.size.width = width
          rect.size.height = height

          w.setFrame(rect, display: false)
        }

        if userSettings.showIndicatorBehindAppWindows {
          w.orderBack(self)
        } else {
          w.orderFront(self)
        }
      }
    }
  }

  private func updateColorByInputSource() {
    // ------------------------------------------------------------
    // check customized language color
    let inputsourceid = WorkspaceData.shared.currentInputSourceID

    if let colors = userSettings.customizedLanguageColor(inputSourceID: inputsourceid) {
      setColors(colors)
      return
    }

    // ------------------------------------------------------------
    // default language color
    let inputmodeid = WorkspaceData.shared.currentInputModeID

    if inputmodeid != "" {
      if inputmodeid == "com.apple.inputmethod.Japanese.Katakana" {
        setColors((Color.white, Color.green, Color.white))
      } else if inputmodeid == "com.apple.inputmethod.Japanese.HalfWidthKana" {
        setColors((Color.white, Color.purple, Color.white))
      } else if inputmodeid == "com.apple.inputmethod.Japanese.FullWidthRoman" {
        setColors((Color.white, Color.yellow, Color.white))
      } else if inputmodeid.hasPrefix("com.apple.inputmethod.Japanese") {
        setColors((Color.white, Color.red, Color.white))
      } else if inputmodeid.hasPrefix("com.apple.inputmethod.TCIM") {
        // TradChinese
        setColors((Color.red, Color.red, Color.red))
      } else if inputmodeid.hasPrefix("com.apple.inputmethod.SCIM") {
        // SimpChinese
        setColors((Color.red, Color.red, Color.red))
      } else if inputmodeid.hasPrefix("com.apple.inputmethod.Korean") {
        setColors((Color.red, Color.blue, Color.clear))
      } else if inputmodeid.hasPrefix("com.apple.inputmethod.Roman") {
        setColors((Color.clear, Color.clear, Color.clear))
      } else {
        setColors((Color.gray, Color.gray, Color.gray))
      }
    } else {
      if inputsourceid.hasPrefix("com.apple.keylayout.British") {
        setColors((Color.blue, Color.red, Color.blue))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Canadian") {
        setColors((Color.red, Color.white, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.French") {
        setColors((Color.blue, Color.white, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.German") {
        setColors((Color.gray, Color.red, Color.yellow))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Italian") {
        setColors((Color.green, Color.white, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Kazakh") {
        setColors((Color.blue, Color.yellow, Color.blue))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Portuguese") {
        setColors((Color.green, Color.red, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Russian") {
        setColors((Color.white, Color.blue, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Swedish") {
        setColors((Color.blue, Color.yellow, Color.blue))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Spanish") {
        setColors((Color.red, Color.yellow, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Swiss") {
        setColors((Color.red, Color.white, Color.red))

      } else if inputsourceid.hasPrefix("com.apple.keylayout.Dvorak") {
        setColors((Color.gray, Color.gray, Color.gray))

      } else if inputsourceid.hasPrefix(
        "com.apple.keyboardlayout.fr-dvorak-bepo.keylayout.FrenchDvorak")
      {
        setColors((Color.gray, Color.gray, Color.gray))

      } else {
        setColors((Color.clear, Color.clear, Color.clear))
      }
    }
  }

  private func setColors(_ colors: (Color, Color, Color)) {
    //
    // Calculate opacity
    //

    var opacity = Double(userSettings.indicatorOpacity) / 100

    windows.forEach { w in
      // If indicator size is too large, set transparency in order to avoid the indicator hides all windows.
      let threshold = CGFloat(100)
      if w.frame.width > threshold,
        w.frame.height > threshold
      {
        let maxOpacity: Double = 0.8
        if opacity > maxOpacity {
          opacity = maxOpacity
        }
      }
    }

    //
    // Set colors
    //

    IndicatorColors.shared.colors = (
      colors.0.opacity(opacity),
      colors.1.opacity(opacity),
      colors.2.opacity(opacity)
    )
  }
}
