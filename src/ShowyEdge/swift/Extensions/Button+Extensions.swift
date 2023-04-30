import SwiftUI

// `.tint` and `.role` are available since macOS 12.0, so we cannot use it in order to support macOS 11.0.

extension Button {
  func sidebarButtonStyle(selected: Bool) -> some View {
    // Do not put padding here.
    // The padding area ignores click.
    // Use `buttonLabelStyle` in order to set padding.

    self
      .buttonStyle(PlainButtonStyle())
      .if(selected) {
        $0
          .background(Color.blue)
          .foregroundColor(.white)
      }
      .cornerRadius(5)
  }
}
