import Foundation

@objc protocol DeprecatedOpenAtLoginHelperProtocol {
  func deprecatedOpenAtLoginRegistered(appURL: URL, with reply: @escaping (Bool) -> Void)
  func deprecatedOpenAtLoginUpdate(appURL: URL, register: Bool, with reply: @escaping () -> Void)
}
