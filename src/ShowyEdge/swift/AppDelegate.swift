import AppKit

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var menuController: MenuController!
    @IBOutlet var preferencesWindowController: PreferencesWindowController!

    private var windows: [NSWindow] = []

    private func setupWindows() {
        let screens = NSScreen.screens

        while windows.count < screens.count {
            let w = NSWindow(
                contentRect: .zero,
                styleMask: [
                    .borderless,
                ],
                backing: .buffered,
                defer: false
            )

            // Note: Do not set alpha value for window.
            // Window with alpha value causes glitch at switching a space (Mission Control).

            w.backgroundColor = NSColor.clear
            w.isOpaque = false
            w.hasShadow = false
            w.ignoresMouseEvents = true
            w.collectionBehavior.insert(.canJoinAllSpaces)
            w.collectionBehavior.insert(.ignoresCycle)
            w.collectionBehavior.insert(.stationary)
            w.contentView = IndicatorView(frame: .zero)

            windows.append(w)
        }

        //
        // Update window level
        //

        windows.forEach { w in
            if UserSettings.shared.showIndicatorBehindAppWindows {
                w.level = .normal
            } else {
                w.level = .statusBar
            }
        }
    }

    private func adjustFrame() {
        setupWindows()

        // ----------------------------------------
        let screens = NSScreen.screens
        var firstScreenFrame = NSZeroRect
        if screens.count > 0 {
            firstScreenFrame = screens[0].frame
        }

        for (i, w) in windows.enumerated() {
            let view = w.contentView as! IndicatorView

            var screenFrame = NSZeroRect
            if i < screens.count {
                screenFrame = screens[i].frame
            }

            let menuOriginX = screenFrame.origin.x
            let menuOriginY = firstScreenFrame.size.height - NSMaxY(screenFrame)

            let isFullScreenSpace = !WorkspaceData.shared.menubarOrigins.contains(
                CGPoint(x: menuOriginX,
                        y: menuOriginY))

            var hide = false
            if i >= screens.count {
                hide = true
            } else if UserSettings.shared.hideInFullScreenSpace,
                      isFullScreenSpace
            {
                hide = true
            } else if UserSettings.shared.showIndicatorBehindAppWindows,
                      isFullScreenSpace
            {
                // Hide indicator in full screen space if `Show indicator behind app windows` option is enabled.
                hide = true
            }

            if hide {
                w.orderOut(self)

            } else {
                var rect = screens[i].frame

                if UserSettings.shared.useCustomFrame {
                    let fullWidth = rect.size.width
                    let fullHeight = rect.size.height

                    //
                    // Size
                    //

                    var width = CGFloat(UserSettings.shared.customFrameWidth)
                    var height = CGFloat(UserSettings.shared.customFrameHeight)

                    if UserSettings.shared.customFrameWidthUnit == CustomFrameUnitPercent.rawValue {
                        if width > 100 {
                            width = 100
                        }
                        width = fullWidth * (width / 100)
                    }

                    if UserSettings.shared.customFrameHeightUnit == CustomFrameUnitPercent.rawValue {
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

                    var top = CGFloat(UserSettings.shared.customFrameTop)
                    var left = CGFloat(UserSettings.shared.customFrameLeft)

                    if UserSettings.shared.customFrameOrigin == CustomFrameOriginUpperLeft.rawValue ||
                        UserSettings.shared.customFrameOrigin == CustomFrameOriginUpperRight.rawValue
                    {
                        top = fullHeight - top - height
                    }

                    if UserSettings.shared.customFrameOrigin == CustomFrameOriginUpperRight.rawValue ||
                        UserSettings.shared.customFrameOrigin == CustomFrameOriginLowerRight.rawValue
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
                    var height = CGFloat(UserSettings.shared.indicatorHeightPx)
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

                    let adjustHeight = view.adjustHeight

                    rect.origin.x += 0
                    rect.origin.y += rect.size.height - height
                    rect.size.width = width
                    rect.size.height = height + adjustHeight

                    w.setFrame(rect, display: false)
                }

                let windowFrame = w.frame
                view.frame = NSMakeRect(0, 0, windowFrame.size.width, windowFrame.size.height)

                if UserSettings.shared.showIndicatorBehindAppWindows {
                    w.orderBack(self)
                } else {
                    w.orderFront(self)
                }
            }
        }
    }

    private func setColors(_ colors: (NSColor, NSColor, NSColor)) {
        windows.forEach { w in
            let view = w.contentView as! IndicatorView
            view.setColors(colors)
        }
    }

    private func updateColorByInputSource() {
        // ------------------------------------------------------------
        // check customized language color
        let inputsourceid = WorkspaceData.shared.currentInputSourceID

        if let colors = UserSettings.shared.customizedLanguageColor(inputSourceID: inputsourceid) {
            setColors(colors)
            return
        }

        // ------------------------------------------------------------
        // default language color
        let inputmodeid = WorkspaceData.shared.currentInputModeID

        if inputmodeid != "" {
            if inputmodeid == "com.apple.inputmethod.Japanese.Katakana" {
                setColors((NSColor.white, NSColor.green, NSColor.white))
            } else if inputmodeid == "com.apple.inputmethod.Japanese.HalfWidthKana" {
                setColors((NSColor.white, NSColor.purple, NSColor.white))
            } else if inputmodeid == "com.apple.inputmethod.Japanese.FullWidthRoman" {
                setColors((NSColor.white, NSColor.yellow, NSColor.white))
            } else if inputmodeid.hasPrefix("com.apple.inputmethod.Japanese") {
                setColors((NSColor.white, NSColor.red, NSColor.white))
            } else if inputmodeid.hasPrefix("com.apple.inputmethod.TCIM") {
                // TradChinese
                setColors((NSColor.red, NSColor.red, NSColor.red))
            } else if inputmodeid.hasPrefix("com.apple.inputmethod.SCIM") {
                // SimpChinese
                setColors((NSColor.red, NSColor.red, NSColor.red))
            } else if inputmodeid.hasPrefix("com.apple.inputmethod.Korean") {
                setColors((NSColor.red, NSColor.blue, NSColor.clear))
            } else if inputmodeid.hasPrefix("com.apple.inputmethod.Roman") {
                setColors((NSColor.clear, NSColor.clear, NSColor.clear))
            } else {
                setColors((NSColor.gray, NSColor.gray, NSColor.gray))
            }
        } else {
            if inputsourceid.hasPrefix("com.apple.keylayout.British") {
                setColors((NSColor.blue, NSColor.red, NSColor.blue))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Canadian") {
                setColors((NSColor.red, NSColor.white, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.French") {
                setColors((NSColor.blue, NSColor.white, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.German") {
                setColors((NSColor.gray, NSColor.red, NSColor.yellow))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Italian") {
                setColors((NSColor.green, NSColor.white, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Kazakh") {
                setColors((NSColor.blue, NSColor.yellow, NSColor.blue))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Portuguese") {
                setColors((NSColor.green, NSColor.red, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Russian") {
                setColors((NSColor.white, NSColor.blue, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Swedish") {
                setColors((NSColor.blue, NSColor.yellow, NSColor.blue))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Spanish") {
                setColors((NSColor.red, NSColor.yellow, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Swiss") {
                setColors((NSColor.red, NSColor.white, NSColor.red))

            } else if inputsourceid.hasPrefix("com.apple.keylayout.Dvorak") {
                setColors((NSColor.gray, NSColor.gray, NSColor.gray))

            } else if inputsourceid.hasPrefix("com.apple.keyboardlayout.fr-dvorak-bepo.keylayout.FrenchDvorak") {
                setColors((NSColor.gray, NSColor.gray, NSColor.gray))

            } else {
                setColors((NSColor.clear, NSColor.clear, NSColor.clear))
            }
        }
    }

    public func applicationDidFinishLaunching(_: Notification) {
        NSApplication.shared.disableRelaunchOnLogin()

        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil,
                                                          queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
        }

        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
        }

        NotificationCenter.default.addObserver(forName: WorkspaceData.fullScreenModeChanged,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
        }

        NotificationCenter.default.addObserver(forName: WorkspaceData.currentInputSourceChanged,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
            self.updateColorByInputSource()
        }

        NotificationCenter.default.addObserver(forName: PreferencesWindowController.indicatorConfigurationChangedNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
            self.updateColorByInputSource()
        }

        NotificationCenter.default.addObserver(forName: UserSettings.indicatorConfigurationChanged,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.adjustFrame()
            self.updateColorByInputSource()
        }

        NotificationCenter.default.addObserver(forName: UserSettings.showMenuSettingChanged,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.menuController.show()
        }

        WorkspaceData.shared.start()

        Updater.checkForUpdatesInBackground()

        preferencesWindowController.setup()
        menuController.show()
    }

    public func applicationShouldHandleReopen(_: NSApplication,
                                              hasVisibleWindows _: Bool) -> Bool
    {
        preferencesWindowController.show()
        return true
    }
}
