import Combine
import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    static let showMenuSettingChanged = Notification.Name("ShowMenuSettingChanged")
    static let indicatorConfigurationChanged = Notification.Name("IndicatorConfigurationChanged")

    @Published var openAtLogin = OpenAtLogin.enabled {
        didSet {
            OpenAtLogin.enabled = openAtLogin
        }
    }

    //
    // Menu settings
    //

    @UserDefault("kShowIconInMenubar", defaultValue: true)
    var showMenu: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.showMenuSettingChanged,
                object: nil
            )
        }
    }

    //
    // Indicator settings
    //

    @UserDefault("CustomizedLanguageColor", defaultValue: [])
    var customizedLanguageColors: [[String: String]] {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    func addCustomizedLanguageColor(_ inputSourceID: String) {
        if inputSourceID == "" {
            return
        }

        //
        // Skip if inputSourceId already exists
        //

        if customizedLanguageColorIndex(inputSourceID: inputSourceID) != nil {
            return
        }

        //
        // Add new entry
        //

        var colors = customizedLanguageColors
        colors.append([
            "inputsourceid": inputSourceID,
            "color0": "#ff0000ff",
            "color1": "#ff0000ff",
            "color2": "#ff0000ff",
        ])

        colors.sort {
            ($0["inputsourceid"] ?? "") < ($1["inputsourceid"] ?? "")
        }

        customizedLanguageColors = colors
    }

    func customizedLanguageColorIndex(inputSourceID: String) -> Int? {
        return customizedLanguageColors.firstIndex(where: { $0["inputsourceid"] == inputSourceID })
    }

    func customizedLanguageColor(inputSourceID: String) -> (NSColor, NSColor, NSColor)? {
        if let color = customizedLanguageColors.first(where: { $0["inputsourceid"] == inputSourceID }) {
            return (
                ColorUtilities.color(from: color["color0"] ?? ""),
                ColorUtilities.color(from: color["color1"] ?? ""),
                ColorUtilities.color(from: color["color2"] ?? "")
            )
        }

        return nil
    }

    @UserDefault("kIndicatorHeightPx", defaultValue: 5)
    var indicatorHeightPx: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kIndicatorOpacity2", defaultValue: 100)
    var indicatorOpacity: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kHideInFullScreenSpace", defaultValue: false)
    var hideInFullScreenSpace: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kShowIndicatorBehindAppWindows", defaultValue: false)
    var showIndicatorBehindAppWindows: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kColorsLayoutOrientation", defaultValue: "horizontal")
    var colorsLayoutOrientation: String {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kUseCustomFrame", defaultValue: false)
    var useCustomFrame: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameOrigin", defaultValue: 0)
    var customFrameOrigin: Int {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameLeft", defaultValue: 0)
    var customFrameLeft: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameTop", defaultValue: 0)
    var customFrameTop: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameWidth", defaultValue: 100)
    var customFrameWidth: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameWidthUnit", defaultValue: 0)
    var customFrameWidthUnit: Int {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameHeight", defaultValue: 100)
    var customFrameHeight: Double {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }

    @UserDefault("kCustomFrameHeightUnit", defaultValue: 0)
    var customFrameHeightUnit: Int {
        willSet {
            objectWillChange.send()
        }
        didSet {
            NotificationCenter.default.post(
                name: UserSettings.indicatorConfigurationChanged,
                object: nil
            )
        }
    }
}
