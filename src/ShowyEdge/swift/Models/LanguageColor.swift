import SwiftUI

@MainActor
class LanguageColor: @MainActor Identifiable, @MainActor Equatable {
  var id: String
  var inputSourceID: String
  var colors: (Color, Color, Color)
  var textPillBackgroundColor: Color
  var textPillForegroundColor: Color
  var textPillLabel: String

  init(
    _ inputSourceID: String,
    _ colors: (Color, Color, Color),
    textPillBackgroundColor: Color? = nil,
    textPillForegroundColor: Color? = nil,
    textPillLabel: String? = nil
  ) {
    id = inputSourceID
    self.inputSourceID = inputSourceID
    self.colors = colors
    self.textPillBackgroundColor =
      textPillBackgroundColor
      ?? LanguageColor.defaultTextPillBackgroundColor(colors: colors)
    self.textPillForegroundColor = textPillForegroundColor ?? Color.white
    let trimmedTextPillLabel = textPillLabel?.trimmingCharacters(in: .whitespacesAndNewlines)
    self.textPillLabel =
      if let trimmedTextPillLabel,
        !trimmedTextPillLabel.isEmpty
      {
        trimmedTextPillLabel
      } else {
        InputSourceShortLabel.make(
          inputSourceID: inputSourceID
        )
      }
  }

  static func == (lhs: LanguageColor, rhs: LanguageColor) -> Bool {
    return lhs.id == rhs.id
  }

  // Derive an initial text pill background from the existing color indicator settings.
  // Ignore transparent colors and prefer a non-white color so white text stays readable.
  private static func defaultTextPillBackgroundColor(colors: (Color, Color, Color)) -> Color {
    let visibleColors = [colors.0, colors.1, colors.2].filter { color in
      color.components.opacity > 0.01
    }

    return visibleColors.first { color in
      let components = color.components
      return components.red < 0.9 || components.green < 0.9 || components.blue < 0.9
    } ?? visibleColors.first ?? Color.blue
  }
}

@propertyWrapper
@MainActor
struct LanguageColorsAppStorage {
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
          let colors = (
            Color(colorString: $0["color0"] ?? ""),
            Color(colorString: $0["color1"] ?? ""),
            Color(colorString: $0["color2"] ?? "")
          )

          languageColors.append(
            LanguageColor(
              inputSourceID,
              colors,
              textPillBackgroundColor: $0["text_pill_background_color"].map(Color.init),
              textPillForegroundColor: $0["text_pill_foreground_color"].map(Color.init),
              textPillLabel: $0["text_pill_label"]
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
          "text_pill_background_color": $0.textPillBackgroundColor.hexString,
          "text_pill_foreground_color": $0.textPillForegroundColor.hexString,
          "text_pill_label": $0.textPillLabel,
        ])
      }
      UserDefaults.standard.set(languageColors, forKey: key)
    }
  }
}
