class PreferencesWindowController: NSWindowController {
    @objc
    public static let indicatorConfigurationChangedNotification = Notification.Name("kIndicatorConfigurationChangedNotification")

    @IBOutlet var menuController: MenuController!
    @IBOutlet var resumeAtLoginCheckbox: NSButton!
    @IBOutlet var inputSourcesTableView: NSTableView!
    @IBOutlet var currentInputSourceID: NSTextField!
    @IBOutlet var versionText: NSTextField!

    func setup() {
        NSColorPanel.shared.showsAlpha = true

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        versionText.stringValue = version
        if OpenAtLogin.enabled {
            resumeAtLoginCheckbox.state = NSControl.StateValue.on
        } else {
            resumeAtLoginCheckbox.state = NSControl.StateValue.off
        }

        inputSourcesTableView.reloadData()

        NotificationCenter.default.addObserver(forName: WorkspaceData.currentInputSourceChanged,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.currentInputSourceID.stringValue = WorkspaceData.shared.currentInputSourceID
        }

        currentInputSourceID.stringValue = WorkspaceData.shared.currentInputSourceID
    }

    func show() {
        window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    @IBAction func addInputSourceID(_: Any) {
        let inputSourceID = WorkspaceData.shared.currentInputSourceID
        if inputSourceID == "" {
            return
        }

        PreferencesManager.addCustomizedLanguageColor(inputSourceID)
        inputSourcesTableView.reloadData()

        let rowIndex = PreferencesManager.getCustomizedLanguageColorIndex(byInputSourceId: inputSourceID)
        if rowIndex >= 0 {
            inputSourcesTableView.selectRowIndexes(NSIndexSet(index: rowIndex) as IndexSet, byExtendingSelection: false)
            inputSourcesTableView.scrollRowToVisible(rowIndex)
        }

        NotificationCenter.default.post(name: PreferencesWindowController.indicatorConfigurationChangedNotification, object: nil)
    }

    @IBAction func quit(_: Any) {
        NSApp.terminate(nil)
    }

    @IBAction func checkForUpdatesStableOnly(_: Any) {
        Updater.checkForUpdatesStableOnly()
    }

    @IBAction func checkForUpdatesWithBetaVersion(_: Any) {
        Updater.checkForUpdatesWithBetaVersion()
    }

    @IBAction func indicatorConfigurationChanged(_: Any) {
        NotificationCenter.default.post(name: PreferencesWindowController.indicatorConfigurationChangedNotification, object: nil)
    }

    @IBAction func menubarIconConfigurationChanged(_: Any) {
        menuController.show()
    }

    @IBAction func resumeAtLoginChanged(_: Any) {
        let bundlePath = Bundle.main.bundlePath

        // Skip if the current app is not the distributed file.

        if
            // from Xcode
            bundlePath.hasSuffix("/Build/Products/Release/ShowyEdge.app") ||
            // from command line
            bundlePath.hasSuffix("/build/Release/ShowyEdge.app")
        {
            print("Skip setting LaunchAtLogin.enabled for dev")
            return
        }

        OpenAtLogin.enabled = (resumeAtLoginCheckbox.state == NSControl.StateValue.on)
    }

    @IBAction func openOfficialWebsite(_: Any) {
        NSWorkspace.shared.open(URL(string: "https://showyedge.pqrs.org")!)
    }

    @IBAction func openGitHub(_: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/pqrs-org/ShowyEdge")!)
    }
}
