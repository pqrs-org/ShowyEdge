import Carbon

@MainActor
public enum InputSourceShortLabel {
  // Builds a short label from the primary language reported by TIS for the input source ID.
  //
  // The primary language is the first entry of kTISPropertyInputSourceLanguages.
  // Examples from tools/dump-input-sources --all-installed:
  //
  // - com.apple.keylayout.ABC: ["en", "af", ..., "hi_Latn", ...]
  // - com.apple.inputmethod.Kotoeri.RomajiTyping: ["ja", "en"]
  // - com.apple.inputmethod.TCIM: ["zh-Hant"]
  // - com.apple.inputmethod.SCIM: ["zh-Hans"]
  // - com.apple.keylayout.UnicodeHexInput: ["", "af", ...]
  //
  // The language tag is reduced to its leading code, e.g. "zh-Hant" -> "ZH".
  // If the primary language is nil or empty, use the input source ID suffix instead,
  // e.g. "com.apple.keylayout.UnicodeHexInput" -> "UN".
  public static func make(inputSourceID: String) -> String {
    make(
      inputSourceID: inputSourceID,
      primaryLanguage: primaryLanguage(inputSourceID: inputSourceID)
    )
  }

  static func make(
    inputSourceID: String,
    primaryLanguage: String?
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

  static func primaryLanguage(inputSourceID: String) -> String? {
    let hasLoadedPrimaryLanguages = primaryLanguages != nil

    if !hasLoadedPrimaryLanguages {
      primaryLanguages = loadPrimaryLanguages()
    }

    if let primaryLanguage = primaryLanguages?[inputSourceID] {
      return primaryLanguage
    }

    if hasLoadedPrimaryLanguages {
      primaryLanguages = loadPrimaryLanguages()
      return primaryLanguages?[inputSourceID]
    }

    return nil
  }

  // Cache primary languages by input source ID to reduce TIS API calls because
  // label generation can run during view updates.
  // If an input source ID is missing from the cache, reload before falling back
  // so an input source added after the initial load can still be picked up.
  private static var primaryLanguages: [String: String]?

  private static func loadPrimaryLanguages() -> [String: String] {
    var primaryLanguages: [String: String] = [:]

    inputSources().forEach { inputSource in
      if let inputSourceID = inputSource.inputSourceID,
        let primaryLanguage = inputSource.primaryLanguage
      {
        primaryLanguages[inputSourceID] = primaryLanguage
      }
    }

    return primaryLanguages
  }

  private static func inputSources() -> [TISInputSource] {
    guard
      let inputSources = TISCreateInputSourceList(nil, true)?.takeRetainedValue()
        as? [TISInputSource]
    else { return [] }

    return inputSources
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
