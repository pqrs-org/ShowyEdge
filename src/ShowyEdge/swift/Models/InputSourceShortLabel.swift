public enum InputSourceShortLabel {
  public static func make(
    inputSourceID: String,
    primaryLanguage: String? = nil
  ) -> String {
    if let primaryLanguage,
      !primaryLanguage.isEmpty
    {
      // TIS kTISPropertyInputSourceLanguages returns language tags.
      // Examples from tools/dump-input-sources --all-installed:
      //
      // - com.apple.keylayout.ABC: ["en", "af", ..., "hi_Latn", ...]
      // - com.apple.inputmethod.Kotoeri.RomajiTyping: ["ja", "en"]
      // - com.apple.inputmethod.TCIM: ["zh-Hant"]
      // - com.apple.inputmethod.SCIM: ["zh-Hans"]
      // - com.apple.keylayout.UnicodeHexInput: ["", "af", ...]
      //
      // Show only the primary language code.
      // If the primary language is empty, fall back to the input source ID suffix below.
      let components = primaryLanguage.split { character in
        character == "-" || character == "_"
      }

      return shortLabel(String(components.first ?? ""))
    }

    if let lastComponent = inputSourceID.split(separator: ".").last {
      return shortLabel(String(lastComponent))
    }

    return shortLabel(inputSourceID)
  }

  private static func shortLabel(_ value: String) -> String {
    let compact = String(value.filter { $0.isLetter || $0.isNumber })
      .uppercased()

    if compact.isEmpty {
      return "---"
    }

    if compact.count <= 3 {
      return compact
    }

    return String(compact.prefix(2))
  }
}
