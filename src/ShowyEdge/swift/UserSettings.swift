import Combine
import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    static let showMenuSettingChanged = Notification.Name("ShowMenuSettingChanged")

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
}
