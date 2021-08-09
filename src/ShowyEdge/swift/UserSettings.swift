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

    @UserDefault("kIndicatorOpacity2", defaultValue: 100)
    var indicatorOpacity: CGFloat {
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
