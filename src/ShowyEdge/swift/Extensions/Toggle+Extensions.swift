import SwiftUI

@MainActor
extension Toggle {
  func switchToggleStyle() -> some View {
    self
      .toggleStyle(.switch)
      .controlSize(.small)
      .font(.body)
  }
}
