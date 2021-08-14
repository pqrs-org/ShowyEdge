import Combine
import Foundation
import SwiftUI

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    static let showMenuSettingChanged = Notification.Name("ShowMenuSettingChanged")
    static let indicatorConfigurationChanged = Notification.Name("IndicatorConfigurationChanged")

    init() {
        loadCustomizedLanguageColors()
    }

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
    // Color settings
    //

    class LanguageColor: Identifiable {
        var inputSourceID: String
        var colors: (Color, Color, Color)

        init(_ inputSourceID: String, _ colors: (Color, Color, Color)) {
            self.inputSourceID = inputSourceID
            self.colors = colors
        }
    }

    @Published var customizedLanguageColors: [LanguageColor] = []

    func customizedLanguageColorIndex(inputSourceID: String) -> Int? {
        return customizedLanguageColors.firstIndex(where: { $0.inputSourceID == inputSourceID })
    }

    func customizedLanguageColor(inputSourceID: String) -> (Color, Color, Color)? {
        if let color = customizedLanguageColors.first(where: { $0.inputSourceID == inputSourceID }) {
            return color.colors
        }

        return nil
    }

    private func loadCustomizedLanguageColors() {
        (UserDefaults.standard.object(forKey: "CustomizedLanguageColor") as? [[String: String]] ?? []).forEach {
            let inputSourceID = $0["inputsourceid"] ?? ""
            if inputSourceID != "" {
                self.customizedLanguageColors.append(LanguageColor(
                    inputSourceID,
                    (
                        Color(colorString: $0["color0"] ?? ""),
                        Color(colorString: $0["color1"] ?? ""),
                        Color(colorString: $0["color2"] ?? "")
                    )
                ))
            }
        }
    }

    func saveCustomizedLanguageColors() {
        var languageColors: [[String: String]] = []
        customizedLanguageColors.forEach {
            let hexStrings = (
                $0.colors.0.hexString,
                $0.colors.1.hexString,
                $0.colors.2.hexString
            )
            languageColors.append([
                "inputsourceid": $0.inputSourceID,
                "color0": hexStrings.0,
                "color1": hexStrings.1,
                "color2": hexStrings.2,
            ])
        }

        // UserDefaults.standard.set(languageColors, forKey: "CustomizedLanguageColor")

        NotificationCenter.default.post(
            name: UserSettings.indicatorConfigurationChanged,
            object: nil
        )
    }

    func appendCustomizedLanguageColor(_ inputSourceID: String) {
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

        objectWillChange.send()

        customizedLanguageColors.append(LanguageColor(inputSourceID, (Color.red, Color.red, Color.red)))

        customizedLanguageColors.sort {
            $0.inputSourceID < $1.inputSourceID
        }

        saveCustomizedLanguageColors()
    }

    func removeCustomizedLanguageColor(_ inputSourceID: String) {
        objectWillChange.send()

        customizedLanguageColors.removeAll(where: { $0.inputSourceID == inputSourceID })

        saveCustomizedLanguageColors()
    }

    //
    // Indicator settings
    //

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
