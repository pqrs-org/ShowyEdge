import SwiftUI
import XCTest

@testable import ShowyEdge

final class ColorExtensionsTests: XCTestCase {
  func testAccentColorComponentsDoNotCrash() {
    let components = Color.accentColor.components

    XCTAssertGreaterThanOrEqual(components.red, 0)
    XCTAssertLessThanOrEqual(components.red, 1)
    XCTAssertGreaterThanOrEqual(components.green, 0)
    XCTAssertLessThanOrEqual(components.green, 1)
    XCTAssertGreaterThanOrEqual(components.blue, 0)
    XCTAssertLessThanOrEqual(components.blue, 1)
    XCTAssertGreaterThanOrEqual(components.opacity, 0)
    XCTAssertLessThanOrEqual(components.opacity, 1)
  }
}
