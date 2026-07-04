public enum InputSourceShortLabel {
  // Builds a short label from the primary language reported by TIS.
  //
  // primaryLanguage is the first entry of kTISPropertyInputSourceLanguages.
  // Examples from tools/dump-input-sources --all-installed:
  //
  // - com.apple.keylayout.ABC: ["en", "af", ..., "hi_Latn", ...]
  // - com.apple.inputmethod.Kotoeri.RomajiTyping: ["ja", "en"]
  // - com.apple.inputmethod.TCIM: ["zh-Hant"]
  // - com.apple.inputmethod.SCIM: ["zh-Hans"]
  // - com.apple.keylayout.UnicodeHexInput: ["", "af", ...]
  //
  // The language tag is reduced to its leading code, e.g. "zh-Hant" -> "ZH".
  // If primaryLanguage is nil or empty, use the input source ID suffix instead,
  // e.g. "com.apple.keylayout.UnicodeHexInput" -> "UN".
  public static func make(
    inputSourceID: String,
    primaryLanguage: String? = nil
  ) -> String {
    if let primaryLanguage,
      !primaryLanguage.isEmpty
    {
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
