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
}

enum CustomFrameUnit: Int {
  // This value is saved into NSUserDefaults.
  // Do not change existing values.

  case pixel
  case percent
}

final class UserSettings: ObservableObject {
  @AppStorage("initialOpenAtLoginRegistered") var initialOpenAtLoginRegistered = false

  //
  // Indicator settings
  //

  @AppStorage("kIndicatorHeightPx") var indicatorHeightPx = 5.0
  @AppStorage("kIndicatorOpacity2") var indicatorOpacity = 100.0
  @AppStorage("kHideInFullScreenSpace") var hideIfMenuBarIsHidden = false
  @AppStorage("kShowIndicatorBehindAppWindows") var showIndicatorBehindAppWindows = false
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
  // Color settings
  //

  @LanguageColorsAppStorage("CustomizedLanguageColor")
  var customizedLanguageColors {
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
}
