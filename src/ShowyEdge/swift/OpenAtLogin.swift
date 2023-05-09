import Foundation
import ServiceManagement

final class OpenAtLogin: ObservableObject {
  static let shared = OpenAtLogin()

  @Published var registered = false

  var error = ""

  init() {
    if #available(macOS 13.0, *) {
      registered = SMAppService.mainApp.status == .enabled
    } else {
      Task {
        await DeprecatedOpenAtLogin.shared.updateRegistered()
      }
    }
  }

  func developmentBinary() -> Bool {
    let bundlePath = Bundle.main.bundlePath

    // Xcode builds
    // - /Build/Products/Debug/*.app
    // - /Build/Products/Release/*.app
    if bundlePath.contains("/Build/") {
      return true
    }

    // Command line builds
    // - /build/Release/*.app
    if bundlePath.contains("/build/") {
      return true
    }

    return false
  }

  @MainActor
  func update(register: Bool) {
    error = ""

    if #available(macOS 13.0, *) {
      do {
        if register {
          try SMAppService.mainApp.register()
        } else {
          // `unregister` throws `Operation not permitted` error in the following cases.
          //
          // 1. `unregister` is called.
          // 2. macOS is restarted to clean up login items entries.
          // 3. `unregister` is called again.
          //
          // So, we ignore the error of `unregister`.

          try? SMAppService.mainApp.unregister()
        }

        registered = register
      } catch {
        self.error = error.localizedDescription
      }
    } else {
      Task {
        await DeprecatedOpenAtLogin.shared.update(register: register)
      }
    }
  }
}
