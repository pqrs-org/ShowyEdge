import ShowyEdge
import XCTest

final class InputSourceShortLabelTests: XCTestCase {
  func testUsesPrimaryLanguageCode() {
    XCTAssertEqual(
      InputSourceShortLabel.make(
        inputSourceID: "com.apple.inputmethod.Japanese",
        primaryLanguage: "ja"
      ),
      "JA"
    )
  }

  func testUsesPrimaryLanguageCodeFromLocaleIdentifier() {
    XCTAssertEqual(
      InputSourceShortLabel.make(
        inputSourceID: "com.apple.keylayout.US",
        primaryLanguage: "en-US"
      ),
      "EN"
    )
  }

  func testFallsBackToInputSourceIDWhenPrimaryLanguageIsEmpty() {
    XCTAssertEqual(
      InputSourceShortLabel.make(
        inputSourceID: "com.apple.keylayout.UnicodeHexInput",
        primaryLanguage: ""
      ),
      "UN"
    )
  }

  func testFallsBackToInputSourceIDWhenLanguagesAreUnavailable() {
    XCTAssertEqual(
      InputSourceShortLabel.make(
        inputSourceID: "com.example.inputsource.CustomKeyboard",
        primaryLanguage: nil
      ),
      "CU"
    )
  }
}
