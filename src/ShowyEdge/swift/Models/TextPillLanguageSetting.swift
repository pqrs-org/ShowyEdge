import SwiftUI

@MainActor
class TextPillLanguageSetting: @MainActor Identifiable, @MainActor Equatable {
  var id: String
  var inputSourceID: String
  var backgroundColor: Color
  var foregroundColor: Color
  var label: String

  init(
    _ inputSourceID: String,
    backgroundColor: Color,
    foregroundColor: Color,
    label: String? = nil
  ) {
    id = inputSourceID
    self.inputSourceID = inputSourceID
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor

    let trimmedLabel = label?.trimmingCharacters(in: .whitespacesAndNewlines)
    self.label =
      if let trimmedLabel,
        !trimmedLabel.isEmpty
      {
        trimmedLabel
      } else {
        InputSourceShortLabel.make(
          inputSourceID: inputSourceID
        )
      }
  }

  static func == (lhs: TextPillLanguageSetting, rhs: TextPillLanguageSetting) -> Bool {
    return lhs.id == rhs.id
  }
}

@propertyWrapper
@MainActor
struct TextPillLanguageSettingsAppStorage {
  let key: String
  let defaultValue: [[String: String]]

  init(_ key: String) {
    self.key = key
    defaultValue = []
  }

  var wrappedValue: [TextPillLanguageSetting] {
    get {
      var settings: [TextPillLanguageSetting] = []
      (UserDefaults.standard.object(forKey: key) as? [[String: String]] ?? []).forEach {
        let inputSourceID = $0["inputSourceID"] ?? ""
        if inputSourceID != "" {
          settings.append(
            TextPillLanguageSetting(
              inputSourceID,
              backgroundColor: Color(colorString: $0["backgroundColor"] ?? ""),
              foregroundColor: Color(colorString: $0["foregroundColor"] ?? ""),
              label: $0["label"]
            ))
        }
      }
      return settings
    }
    nonmutating set {
      var settings: [[String: String]] = []
      newValue.forEach {
        settings.append([
          "inputSourceID": $0.inputSourceID,
          "backgroundColor": $0.backgroundColor.hexString,
          "foregroundColor": $0.foregroundColor.hexString,
          "label": $0.label,
        ])
      }
      UserDefaults.standard.set(settings, forKey: key)
    }
  }
}
