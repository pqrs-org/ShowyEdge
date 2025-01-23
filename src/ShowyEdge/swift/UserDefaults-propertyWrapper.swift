import Foundation
import SwiftUI

@propertyWrapper
struct UserDefaultLanguageColors {
  let key: String
  let defaultValue: [[String: String]]

  init(_ key: String) {
    self.key = key
    defaultValue = []
  }

  var wrappedValue: [LanguageColor] {
    get {
      var languageColors: [LanguageColor] = []
      (UserDefaults.standard.object(forKey: key) as? [[String: String]] ?? []).forEach {
        let inputSourceID = $0["inputsourceid"] ?? ""
        if inputSourceID != "" {
          languageColors.append(
            LanguageColor(
              inputSourceID,
              (
                Color(colorString: $0["color0"] ?? ""),
                Color(colorString: $0["color1"] ?? ""),
                Color(colorString: $0["color2"] ?? "")
              )
            ))
        }
      }
      return languageColors
    }
    nonmutating set {
      var languageColors: [[String: String]] = []
      newValue.forEach {
        let hexStrings = (
          $0.colors.0.hexString,
          $0.colors.1.hexString,
          $0.colors.2.hexString
        )
        languageColors.append([
          "inputsourceid": $0.inputSourceID,
          "color0": hexStrings.0,
          "color1": hexStrings.1,
          "color2": hexStrings.2,
        ])
      }
      UserDefaults.standard.set(languageColors, forKey: key)
    }
  }
}
