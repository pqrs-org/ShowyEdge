@testable import ShowyEdge
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

  func testMakeUsesPrimaryLanguageFromTIS() {
    XCTAssertEqual(
      InputSourceShortLabel.make(inputSourceID: "com.apple.keylayout.ABC"),
      "EN"
    )
  }

  func testMakeFallsBackToInputSourceIDWhenTISSourceIsUnavailable() {
    XCTAssertEqual(
      InputSourceShortLabel.make(inputSourceID: "com.example.inputsource.CustomKeyboard"),
      "CU"
    )
  }

  func testPrimaryLanguageReadsInputSourceLanguagesFromTIS() {
    XCTAssertEqual(
      InputSourceShortLabel.primaryLanguage(inputSourceID: "com.apple.keylayout.ABC"),
      "en"
    )
  }

  func testPrimaryLanguageReturnsNilForUnknownInputSourceID() {
    XCTAssertNil(
      InputSourceShortLabel.primaryLanguage(
        inputSourceID: "com.example.inputsource.CustomKeyboard"
      )
    )
  }
}
