import AppKit
import Carbon
import CoreGraphics
import Foundation

public class WorkspaceData: NSObject, ObservableObject {
  public static let shared = WorkspaceData()
  public static let currentInputSourceChanged = Notification.Name("currentInputSourceChanged")

  @Published var inputSourceNames: [String: String] = [:]
  @Published var currentInputSourceID: String = ""
  @Published var currentInputModeID: String = ""

  public func start() {
    stop()

    DistributedNotificationCenter.default().addObserver(
      self,
      selector: #selector(enabledKeyboardInputSourcesChanged),
      name: kTISNotifyEnabledKeyboardInputSourcesChanged as NSNotification.Name?,
      object: nil,
      suspensionBehavior: .deliverImmediately
    )

    DistributedNotificationCenter.default().addObserver(
      self,
      selector: #selector(selectedKeyboardInputSourceChanged),
      name: kTISNotifySelectedKeyboardInputSourceChanged as NSNotification.Name?,
      object: nil,
      suspensionBehavior: .deliverImmediately
    )

    enabledKeyboardInputSourcesChanged()
    selectedKeyboardInputSourceChanged()
  }

  public func stop() {
    DistributedNotificationCenter.default.removeObserver(self)
  }

  @MainActor
  public func getInputSourceLocalizedName(inputSourceID: String) -> String {
    if let name = inputSourceNames[inputSourceID] {
      return name
    }
    return inputSourceID
  }

  @objc
  private func enabledKeyboardInputSourcesChanged() {
    Task { @MainActor in
      guard
        let inputSourceList = TISCreateInputSourceList(nil, false)?.takeUnretainedValue()
          as? [TISInputSource]
      else { return }

      var newInputSourceNames: [String: String] = [:]

      for inputSource in inputSourceList {
        if let id = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID),
          let name = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName)
        {
          let inputSourceID = String(unsafeBitCast(id, to: CFString.self))
          let localizedName = String(unsafeBitCast(name, to: CFString.self))

          newInputSourceNames[inputSourceID] = localizedName
        }
      }

      inputSourceNames = newInputSourceNames
    }
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
