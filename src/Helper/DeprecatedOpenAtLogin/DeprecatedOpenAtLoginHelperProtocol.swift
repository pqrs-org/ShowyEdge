import Foundation

@objc protocol DeprecatedOpenAtLoginHelperProtocol {
  @available(macOS, deprecated: 12.0)
  func deprecatedOpenAtLoginRegistered(appURL: URL, with reply: @escaping (Bool) -> Void)

  @available(macOS, deprecated: 12.0)
  func deprecatedOpenAtLoginUpdate(appURL: URL, register: Bool, with reply: @escaping () -> Void)
}
