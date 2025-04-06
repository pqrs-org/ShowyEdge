import AsyncAlgorithms
import Combine
import SettingsAccess
import SwiftUI

@MainActor
class IndicatorsController {
  private var userSettings: UserSettings

  private var windows: [NSWindow] = []
  private var menuBarOrigins: [CGPoint] = []
  private var lastActiveWindowRect: NSRect?
  private var lastActiveWindowOwner: String?

  private var cancellables = Set<AnyCancellable>()

  let timer: AsyncTimerSequence<ContinuousClock>
  var timerTask: Task<Void, Never>?

  init(userSettings: UserSettings) {
    self.userSettings = userSettings

    timer = AsyncTimerSequence(
      interval: .seconds(1),
      clock: .continuous
    )

    timerTask = Task { @MainActor in
      self.updateMenuBarOrigins()

      for await _ in timer {
        self.updateMenuBarOrigins()
        if self.userSettings.followActiveWindow {
          self.updateWindowFrames(fromActiveWindow: true)
        }
      }
    }

    NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
      .sink { @MainActor _ in
        self.updateWindowFrames()
      }.store(in: &cancellables)

    NotificationCenter.default.publisher(for: WorkspaceData.currentInputSourceChanged)
      .sink { @MainActor _ in
        self.updateWindowFrames()
        self.updateColorByInputSource()
      }.store(in: &cancellables)

    userSettings.objectWillChange.sink { _ in
      // Use Task to perform processing after the settings are changed.
      Task { @MainActor in
        self.updateWindowFrames()
        self.updateColorByInputSource()
      }
    }.store(in: &cancellables)

    setupWindows()
    updateWindowFrames()
    updateColorByInputSource()
  }

  private func updateMenuBarOrigins() {
    var newMenuBarOrigins: [CGPoint] = []

    let windows = windowsMatching { window in
      return window["kCGWindowOwnerName"] as? String == "Window Server"
        && window["kCGWindowName"] as? String == "Menubar"
    }

    windows.forEach { window in
      if let bounds = window["kCGWindowBounds"] as? [String: Any],
        let x = bounds["X"] as? NSNumber,
        let y = bounds["Y"] as? NSNumber
      {
        newMenuBarOrigins.append(
          CGPoint(
            x: x.doubleValue,
            y: y.doubleValue))
      }
    }

    if menuBarOrigins != newMenuBarOrigins {
      menuBarOrigins = newMenuBarOrigins
      updateWindowFrames()
    }
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
        rootView: IndicatorView(index: windows.count, userSettings: userSettings)
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

  private func updateWindowFrames(fromActiveWindow: Bool = false) {
    setupWindows()

    if fromActiveWindow, !userSettings.followActiveWindow {
      // if not following active window, and the update is requested from active window, do nothing
      return
    }
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

      let menuBarShown = menuBarOrigins.contains(
        CGPoint(
          x: menuOriginX,
          y: menuOriginY))

      var hide = false
      if i >= screens.count {
        hide = true
      } else if userSettings.hideIfMenuBarIsHidden, !menuBarShown {
        hide = true
      }

      if hide {
        w.orderOut(self)

      } else {
        if userSettings.followActiveWindow {
          // quit if active window is not found
          func orderOutWindow() {
            lastActiveWindowRect = nil
            lastActiveWindowOwner = nil
            w.orderOut(self)
          }
          // get active window
          guard let frontmostApp = NSWorkspace.shared.frontmostApplication else {
            orderOutWindow()
            return
          }

          let windows = windowsMatching { window in
            return window["kCGWindowOwnerName"] as? String == frontmostApp.localizedName
              && window["kCGWindowLayer"] as? Int == Optional(0)  // normal layer
          }

          if windows.isEmpty {
            orderOutWindow()
            return
          }

          guard let window = windows.first,
            let bounds = window["kCGWindowBounds"] as? [String: Any],
            let x = bounds["X"] as? NSNumber,
            let y = bounds["Y"] as? NSNumber,
            let width = bounds["Width"] as? NSNumber,
            let height = bounds["Height"] as? NSNumber
          else {
            orderOutWindow()
            return
          }
          let windowFrame = NSRect(
            x: x.doubleValue,
            y: y.doubleValue,
            width: width.doubleValue,
            height: height.doubleValue
          )
          if lastActiveWindowRect != windowFrame
            || lastActiveWindowOwner != frontmostApp.localizedName
          {
            lastActiveWindowRect = windowFrame
            lastActiveWindowOwner = frontmostApp.localizedName
          } else {
            return
          }
          var indicatorFrame = windowFrame
          if userSettings.useCustomFrame {
            // ------- size -------
            let fullWidth = windowFrame.width
            let fullHeight = windowFrame.height
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
            // ------- origin -------
            var top = CGFloat(userSettings.customFrameTop)
            var left = CGFloat(userSettings.customFrameLeft)
            if userSettings.customFrameOrigin == CustomFrameOrigin.upperLeft.rawValue
              || userSettings.customFrameOrigin == CustomFrameOrigin.upperRight.rawValue
            {
              top = top + height
            }

            if userSettings.customFrameOrigin == CustomFrameOrigin.lowerLeft.rawValue
              || userSettings.customFrameOrigin == CustomFrameOrigin.lowerRight.rawValue
            {
              top = fullHeight - top
            }

            if userSettings.customFrameOrigin == CustomFrameOrigin.upperRight.rawValue
              || userSettings.customFrameOrigin == CustomFrameOrigin.lowerRight.rawValue
            {
              left = fullWidth - left - width
            }
            indicatorFrame.origin.x += left
            let screenHeight = NSScreen.main?.frame.height ?? 0
            indicatorFrame.origin.y = screenHeight - windowFrame.origin.y - top
            indicatorFrame.size.width = width
            indicatorFrame.size.height = height
          } else {
            let indicatorHeight = CGFloat(userSettings.indicatorHeightPx)
            let screenHeight = NSScreen.main?.frame.height ?? 0
            indicatorFrame.origin.y = screenHeight - windowFrame.origin.y - indicatorHeight
            indicatorFrame.size.height = indicatorHeight
          }
          w.setFrame(indicatorFrame, display: false)
        } else if !fromActiveWindow {
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
        }
        if userSettings.showIndicatorBehindAppWindows {
          w.orderBack(self)
        } else {
          w.orderFront(self)
        }
      }
    }
  }

  func windowsMatching(_ predicate: ([String: AnyObject]) -> Bool) -> [[String: AnyObject]] {
    guard
      let windows = CGWindowListCopyWindowInfo(
        [.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: AnyObject]]
    else {
      return []
    }

    return windows.filter(predicate)
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
