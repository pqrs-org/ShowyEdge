import Foundation

let windowPositionUpdateNeededNotification = NSNotification.Name("windowPositionUpdateNeeded")
let openSettingsNotification = NSNotification.Name("openSettings")

func postWindowPositionUpdateNeededNotification() {
  NotificationCenter.default.post(
    name: windowPositionUpdateNeededNotification,
    object: nil,
    userInfo: nil)
}
