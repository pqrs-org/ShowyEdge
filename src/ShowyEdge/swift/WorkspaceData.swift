import AppKit
import Carbon
import CoreGraphics
import Foundation

public class WorkspaceData: NSObject, ObservableObject {
  public static let shared = WorkspaceData()
  public static let currentInputSourceChanged = Notification.Name("currentInputSourceChanged")

  @Published var currentInputSourceID: String = ""
  @Published var currentInputModeID: String = ""

  public func start() {
    stop()

    DistributedNotificationCenter.default().addObserver(
      self,
      selector: #selector(selectedKeyboardInputSourceChanged),
      name: kTISNotifySelectedKeyboardInputSourceChanged as NSNotification.Name?,
      object: nil,
      suspensionBehavior: .deliverImmediately
    )

    selectedKeyboardInputSourceChanged()
  }

  public func stop() {
    DistributedNotificationCenter.default.removeObserver(self)
  }

  @objc
  private func selectedKeyboardInputSourceChanged() {
    Task { @MainActor in
      let inputSource = TISCopyCurrentKeyboardInputSource().takeRetainedValue()

      self.currentInputSourceID = inputSource.inputSourceID ?? "unknown"
      self.currentInputModeID = inputSource.inputModeID ?? ""

      NotificationCenter.default.post(
        name: WorkspaceData.currentInputSourceChanged,
        object: nil)
    }
  }
}
