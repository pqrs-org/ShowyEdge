import CoreServices
import Foundation
import ServiceManagement

extension Helper {
  @available(macOS, deprecated: 12.0)
  @objc func deprecatedOpenAtLoginRegistered(appURL: URL, with reply: @escaping (Bool) -> Void) {
    reply(DeprecatedOpenAtLoginObjc.registered(appURL))
  }

  @available(macOS, deprecated: 12.0)
  @objc func deprecatedOpenAtLoginUpdate(
    appURL: URL, register: Bool, with reply: @escaping () -> Void
  ) {
    if register {
      DeprecatedOpenAtLoginObjc.register(appURL)
    } else {
      DeprecatedOpenAtLoginObjc.unregister(appURL)
    }

    reply()
  }
}
