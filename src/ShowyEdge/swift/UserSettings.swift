import Combine
import Foundation
import SwiftUI

enum CustomFrameOrigin: Int {
  // This value is saved into NSUserDefaults.
  // Do not change existing values.

  case upperLeft
  case lowerLeft
  case upperRight
  case lowerRight

  static let allCases: [CustomFrameOrigin] = [
    .upperLeft,
    .lowerLeft,
    .upperRight,
    .lowerRight,
  ]
}

enum CustomFrameUnit: Int {
  // This value is saved into NSUserDefaults.
  // Do not change existing values.

  case pixel
  case percent
}

enum IndicatorDisplayMode: String {
  case colors
  case textPill
}

@MainActor
final class UserSettings: ObservableObject {
  @AppStorage("initialOpenAtLoginRegistered") var initialOpenAtLoginRegistered = false
  @AppStorage("showAdditionalMenuItems") var showAdditionalMenuItems: Bool = false

  //
  // Indicator settings
  //

  @AppStorage("kIndicatorHeightPx") var indicatorHeightPx = 5.0
  @AppStorage("kIndicatorOpacity2") var indicatorOpacity = 100.0
  @AppStorage("kHideInFullScreenSpace") var hideIfMenuBarIsHidden = false
  @AppStorage("kShowIndicatorBehindAppWindows") var showIndicatorBehindAppWindows = false
  @AppStorage("kIndicatorDisplayMode") var indicatorDisplayMode = IndicatorDisplayMode.colors
    .rawValue
  @AppStorage("kColorsLayoutOrientation") var colorsLayoutOrientation = "horizontal"
  @AppStorage("kUseCustomFrame") var useCustomFrame = false
  @AppStorage("kFollowActiveWindow") var followActiveWindow = false
  @AppStorage("minWindowWidthToFollowActiveWindow") var minWindowWidthToFollowActiveWindow = 100.0
  @AppStorage("minWindowHeightToFollowActiveWindow") var minWindowHeightToFollowActiveWindow = 100.0
  @AppStorage("followFinderActiveWindow") var followFinderActiveWindow = false
  @AppStorage("kCustomFrameOrigin") var customFrameOrigin = 0
  @AppStorage("kCustomFrameLeft") var customFrameLeft = 0.0
  @AppStorage("kCustomFrameTop") var customFrameTop = 0.0
  @AppStorage("kCustomFrameWidth") var customFrameWidth = 100.0
  @AppStorage("kCustomFrameWidthUnit") var customFrameWidthUnit = 0
  @AppStorage("kCustomFrameHeight") var customFrameHeight = 100.0
  @AppStorage("kCustomFrameHeightUnit") var customFrameHeightUnit = 0
  @AppStorage("kCustomFramePillShape") var customFramePillShape = false

  //
  // Text pill settings
  //

  @AppStorage("textPillFontSize") var textPillFontSize = 26.0
  @AppStorage("textPillWidth") var textPillWidth = 60.0
  @AppStorage("textPillHeight") var textPillHeight = 30.0
  @AppStorage("textPillOrigin") var textPillOrigin = CustomFrameOrigin.upperRight.rawValue
  @AppStorage("textPillLeft") var textPillLeft = 0.0
  @AppStorage("textPillTop") var textPillTop = 30.0
  @AppStorage("textPillHideOnHover") var textPillHideOnHover = true

  //
  // Color settings
  //

  // Use capitalized names to preserve compatibility.
  @LanguageColorsAppStorage("CustomizedLanguageColor")
  var customizedLanguageColors {
    willSet {
      objectWillChange.send()
    }
  }

  @TextPillLanguageSettingsAppStorage("textPillLanguageSettings")
  var textPillLanguageSettings {
    willSet {
      objectWillChange.send()
    }
  }

  func customizedLanguageColorIndex(inputSourceID: String) -> Int? {
    customizedLanguageColors.firstIndex(where: { $0.inputSourceID == inputSourceID })
  }

  func customizedLanguageColor(inputSourceID: String) -> (Color, Color, Color)? {
    if let color = customizedLanguageColors.first(where: { $0.inputSourceID == inputSourceID }) {
      return color.colors
    }

    return nil
  }

  func customizedLanguageTextPillColor(inputSourceID: String) -> (Color, Color)? {
    if let setting = textPillLanguageSettings.first(where: { $0.inputSourceID == inputSourceID }) {
      return (setting.backgroundColor, setting.foregroundColor)
    }

    return nil
  }

  func textPillColor(inputSourceID: String) -> (Color, Color) {
    if let colors = customizedLanguageTextPillColor(inputSourceID: inputSourceID) {
      return colors
    }

    return Self.textPillColor(backgroundColor: Color.accentColor)
  }

  func customizedLanguageTextPillLabel(inputSourceID: String) -> String? {
    if let setting = textPillLanguageSettings.first(where: { $0.inputSourceID == inputSourceID }) {
      let label = setting.label.trimmingCharacters(in: .whitespacesAndNewlines)
      return label.isEmpty ? nil : label
    }

    return nil
  }

  func textPillLanguageSettingIndex(inputSourceID: String) -> Int? {
    textPillLanguageSettings.firstIndex(where: { $0.inputSourceID == inputSourceID })
  }

  func appendCustomizedLanguageColor(_ inputSourceID: String) {
    if inputSourceID == "" {
      return
    }

    //
    // Skip if inputSourceId already exists
    //

    if customizedLanguageColorIndex(inputSourceID: inputSourceID) != nil {
      return
    }

    //
    // Add new entry
    //

    customizedLanguageColors.append(
      LanguageColor(
        inputSourceID,
        (
          Color(colorString: "#ff0000ff"),
          Color(colorString: "#ff0000ff"),
          Color(colorString: "#ff0000ff")
        )
      )
    )

    customizedLanguageColors.sort {
      $0.inputSourceID < $1.inputSourceID
    }
  }

  func removeCustomizedLanguageColor(_ inputSourceID: String) {
    customizedLanguageColors.removeAll(where: { $0.inputSourceID == inputSourceID })
  }

  func appendTextPillLanguageSetting(_ inputSourceID: String) {
    if inputSourceID == "" {
      return
    }

    if textPillLanguageSettingIndex(inputSourceID: inputSourceID) != nil {
      return
    }

    let colors = Self.textPillColor(backgroundColor: Color.accentColor)

    textPillLanguageSettings.append(
      TextPillLanguageSetting(
        inputSourceID,
        backgroundColor: colors.0,
        foregroundColor: colors.1
      )
    )

    textPillLanguageSettings.sort {
      $0.inputSourceID < $1.inputSourceID
    }
  }

  func removeTextPillLanguageSetting(_ inputSourceID: String) {
    textPillLanguageSettings.removeAll(where: { $0.inputSourceID == inputSourceID })
  }

  private static func textPillColor(backgroundColor: Color) -> (Color, Color) {
    let components = backgroundColor.components
    let luminance =
      0.2126 * components.red
      + 0.7152 * components.green
      + 0.0722 * components.blue

    return (
      backgroundColor,
      luminance > 0.6 ? Color.black : Color.white
    )
  }
}
