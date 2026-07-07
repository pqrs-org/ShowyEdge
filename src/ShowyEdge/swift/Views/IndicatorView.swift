import SettingsAccess
import SwiftUI

struct IndicatorView: View {
  @Environment(\.openSettingsLegacy) var openSettingsLegacy

  let index: Int

  @ObservedObject var userSettings: UserSettings
  @ObservedObject private var indicatorColors = IndicatorColors.shared
  @ObservedObject private var workspaceData = WorkspaceData.shared

  @State private var hiddenTextPill = false

  var body: some View {
    GeometryReader { metrics in
      if userSettings.indicatorDisplayMode == IndicatorDisplayMode.textPill.rawValue {
        textPill(metrics: metrics)
      } else {
        colorBars(metrics: metrics)
      }
    }
    .if(
      userSettings.indicatorDisplayMode == IndicatorDisplayMode.colors.rawValue
        && userSettings.useCustomFrame
        && userSettings.customFramePillShape
    ) {
      $0.clipShape(Capsule())
    }
    .onReceive(NotificationCenter.default.publisher(for: openSettingsNotification)) { _ in
      if index == 0 {
        Task { @MainActor in
          try? openSettingsLegacy()
        }
      }
    }
  }

  @ViewBuilder
  private func colorBars(metrics: GeometryProxy) -> some View {
    if userSettings.colorsLayoutOrientation == "horizontal" {
      HStack(spacing: 0) {
        Rectangle().fill(self.indicatorColors.colors.0).frame(width: metrics.size.width / 3)
        Rectangle().fill(self.indicatorColors.colors.1).frame(width: metrics.size.width / 3)
        Rectangle().fill(self.indicatorColors.colors.2).frame(width: metrics.size.width / 3)
      }
    } else {
      VStack(spacing: 0) {
        Rectangle().fill(self.indicatorColors.colors.0).frame(height: metrics.size.height / 3)
        Rectangle().fill(self.indicatorColors.colors.1).frame(height: metrics.size.height / 3)
        Rectangle().fill(self.indicatorColors.colors.2).frame(height: metrics.size.height / 3)
      }
    }
  }

  private func textPill(metrics: GeometryProxy) -> some View {
    let fontSize = max(CGFloat(userSettings.textPillFontSize), 1)
    let opacity = IndicatorOpacity.adjusted(
      percent: 100,
      size: metrics.size
    )

    return ZStack {
      Capsule()
        .fill(textPillColors.0)

      Text(currentInputSourceLabel)
        .font(.system(size: fontSize, weight: .semibold, design: .rounded))
        .foregroundColor(textPillColors.1)
        .lineLimit(1)
        .minimumScaleFactor(0.05)
        .allowsTightening(true)
        .padding(.horizontal, max(metrics.size.height * 0.18, 2))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .opacity(userSettings.textPillHideOnHover && hiddenTextPill ? 0.0 : opacity)
    .whenHovered { hover in
      if hover && userSettings.textPillHideOnHover {
        withAnimation(.easeInOut(duration: 0.2)) {
          hiddenTextPill = true
        }
      } else {
        hiddenTextPill = false
      }
    }
  }

  private var currentInputSourceLabel: String {
    if let label = userSettings.customizedLanguageTextPillLabel(
      inputSourceID: workspaceData.currentInputSourceID
    ) {
      return label
    }

    return InputSourceShortLabel.make(
      inputSourceID: workspaceData.currentInputSourceID
    )
  }

  private var textPillColors: (Color, Color) {
    userSettings.textPillColor(
      inputSourceID: workspaceData.currentInputSourceID
    )
  }
}
