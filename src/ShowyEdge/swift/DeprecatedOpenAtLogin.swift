import Foundation
import ServiceManagement

// For macOS 12 or prior
actor DeprecatedOpenAtLogin {
  static let shared = DeprecatedOpenAtLogin()

  func updateRegistered() {
    runHelper { proxy in
      proxy.deprecatedOpenAtLoginRegistered(appURL: Bundle.main.bundleURL) { registered in
        Task { @MainActor in
          OpenAtLogin.shared.registered = registered
        }
      }
    }
  }

  func update(register: Bool) {
    runHelper { proxy in
      proxy.deprecatedOpenAtLoginUpdate(appURL: Bundle.main.bundleURL, register: register) {
        Task { @MainActor in
          OpenAtLogin.shared.registered = register
        }
      }
    }
  }

  private func runHelper(
    _ callback: @escaping (DeprecatedOpenAtLoginHelperProtocol) -> Void
  ) {
    let connection = NSXPCConnection(serviceName: helperServiceName)
    connection.remoteObjectInterface = NSXPCInterface(
      with: DeprecatedOpenAtLoginHelperProtocol.self)
    connection.resume()

    if let proxy = connection.synchronousRemoteObjectProxyWithErrorHandler({ error in
      OpenAtLogin.shared.error = error.localizedDescription
    }) as? DeprecatedOpenAtLoginHelperProtocol {
      callback(proxy)
    }

    connection.invalidate()
  }
}
