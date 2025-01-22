import SwiftUI

struct SettingsActionView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 25.0) {
      GroupBox(label: Text("Action")) {
        VStack(alignment: .leading, spacing: 16) {
          Button(
            action: {
              Relauncher.relaunch()
            },
            label: {
              Label("Restart ShowyEdge", systemImage: "arrow.clockwise")
            })

          Button(
            action: {
              NSApplication.shared.terminate(self)
            },
            label: {
              Label("Quit ShowyEdge", systemImage: "xmark")
            })
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}
