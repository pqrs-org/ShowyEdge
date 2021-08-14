import SwiftUI

class LanguageColor: Identifiable {
    var inputSourceID: String
    var colors: (Color, Color, Color)

    init(_ inputSourceID: String, _ colors: (Color, Color, Color)) {
        self.inputSourceID = inputSourceID
        self.colors = colors
    }
}
