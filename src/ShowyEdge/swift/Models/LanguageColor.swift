import SwiftUI

class LanguageColor: Identifiable {
    var id: String
    var inputSourceID: String
    var colors: (Color, Color, Color)

    init(_ inputSourceID: String, _ colors: (Color, Color, Color)) {
        id = inputSourceID
        self.inputSourceID = inputSourceID
        self.colors = colors
    }
}
