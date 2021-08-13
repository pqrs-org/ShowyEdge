import AppKit
import SwiftUI

public extension Color {
    init(colorString: String) {
        if colorString.hasPrefix("#"), colorString.count == 9 {
            // #RRGGBBAA

            if let r = UInt8(colorString[colorString.index(colorString.startIndex, offsetBy: 1) ... colorString.index(colorString.startIndex, offsetBy: 2)], radix: 16),
               let g = UInt8(colorString[colorString.index(colorString.startIndex, offsetBy: 3) ... colorString.index(colorString.startIndex, offsetBy: 4)], radix: 16),
               let b = UInt8(colorString[colorString.index(colorString.startIndex, offsetBy: 5) ... colorString.index(colorString.startIndex, offsetBy: 6)], radix: 16),
               let a = UInt8(colorString[colorString.index(colorString.startIndex, offsetBy: 7) ... colorString.index(colorString.startIndex, offsetBy: 8)], radix: 16)
            {
                self.init(.sRGB,
                          red: Double(r) / 255,
                          green: Double(g) / 255,
                          blue: Double(b) / 255,
                          opacity: Double(a) / 255)
            } else {
                self = .clear
            }

        } else {
            switch colorString {
            // Colors without opacity
            case "black":
                // Adjust color
                self = .gray
            case "blue":
                self = .blue
            case "brown":
                self.init(.sRGB, red: 0.6, green: 0.4, blue: 0.2)
            case "clear":
                self = .clear
            case "cyan":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0)
            case "green":
                self = .green
            case "magenta":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0)
            case "orange":
                self = .orange
            case "purple":
                self = .purple
            case "red":
                self = .red
            case "white":
                self = .white
            case "yellow":
                self = .yellow

            // Colors with opacity

            // black 0.0, 0.0, 0.0
            case "black1.0":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0)
            case "black0.8":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 0.8)
            case "black0.6":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 0.6)
            case "black0.4":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 0.4)
            case "black0.2":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 0.2)

            // gray 0.5, 0.5, 0.5
            case "gray1.0":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1.0)
            case "gray0.8":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.8)
            case "gray0.6":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.6)
            case "gray0.4":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.4)
            case "gray0.2":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2)

            // silver 0.75, 0.75, 0.75
            case "silver1.0":
                self.init(.sRGB, red: 0.75, green: 0.75, blue: 0.75, opacity: 1.0)
            case "silver0.8":
                self.init(.sRGB, red: 0.75, green: 0.75, blue: 0.75, opacity: 0.8)
            case "silver0.6":
                self.init(.sRGB, red: 0.75, green: 0.75, blue: 0.75, opacity: 0.6)
            case "silver0.4":
                self.init(.sRGB, red: 0.75, green: 0.75, blue: 0.75, opacity: 0.4)
            case "silver0.2":
                self.init(.sRGB, red: 0.75, green: 0.75, blue: 0.75, opacity: 0.2)

            // white 1.0f, 1.0f, 1.0f
            case "white1.0":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
            case "white0.8":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.8)
            case "white0.6":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6)
            case "white0.4":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4)
            case "white0.2":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.2)

            // maroon 0.5f, 0.0f, 0.0f
            case "maroon1.0":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.0, opacity: 1.0)
            case "maroon0.8":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.0, opacity: 0.8)
            case "maroon0.6":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.0, opacity: 0.6)
            case "maroon0.4":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.0, opacity: 0.4)
            case "maroon0.2":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.0, opacity: 0.2)

            // red 1.0f, 0.0f, 0.0f
            case "red1.0":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
            case "red0.8":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.8)
            case "red0.6":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.6)
            case "red0.4":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.4)
            case "red0.2":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.2)

            // olive 0.5f, 0.5f, 0.0f
            case "olive1.0":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 1.0)
            case "olive0.8":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 0.8)
            case "olive0.6":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 0.6)
            case "olive0.4":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 0.4)
            case "olive0.2":
                self.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 0.2)

            // yellow 1.0f, 1.0f, 0.0f
            case "yellow1.0":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 0.0, opacity: 1.0)
            case "yellow0.8":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 0.0, opacity: 0.8)
            case "yellow0.6":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 0.0, opacity: 0.6)
            case "yellow0.4":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 0.0, opacity: 0.4)
            case "yellow0.2":
                self.init(.sRGB, red: 1.0, green: 1.0, blue: 0.0, opacity: 0.2)

            // green 0.0f, 0.5f, 0.0f
            case "green1.0":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 1.0)
            case "green0.8":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 0.8)
            case "green0.6":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 0.6)
            case "green0.4":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 0.4)
            case "green0.2":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 0.2)

            // lime 0.0f, 1.0f, 0.0f
            case "lime1.0":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0)
            case "lime0.8":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 0.0, opacity: 0.8)
            case "lime0.6":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 0.0, opacity: 0.6)
            case "lime0.4":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 0.0, opacity: 0.4)
            case "lime0.2":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 0.0, opacity: 0.2)

            // teal 0.0f, 0.5f, 0.5f
            case "teal1.0":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.5, opacity: 1.0)
            case "teal0.8":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.5, opacity: 0.8)
            case "teal0.6":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.5, opacity: 0.6)
            case "teal0.4":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.5, opacity: 0.4)
            case "teal0.2":
                self.init(.sRGB, red: 0.0, green: 0.5, blue: 0.5, opacity: 0.2)

            // aqua 0.0f, 1.0f, 1.0f
            case "aqua1.0":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 1.0)
            case "aqua0.8":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 0.8)
            case "aqua0.6":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 0.6)
            case "aqua0.4":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 0.4)
            case "aqua0.2":
                self.init(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 0.2)

            // navy 0.0f, 0.0f, 0.5f
            case "navy1.0":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 1.0)
            case "navy0.8":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 0.8)
            case "navy0.6":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 0.6)
            case "navy0.4":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 0.4)
            case "navy0.2":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 0.5, opacity: 0.2)

            // blue 0.0f, 0.0f, 1.0f
            case "blue1.0":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 1.0, opacity: 1.0)
            case "blue0.8":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 1.0, opacity: 0.8)
            case "blue0.6":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 1.0, opacity: 0.6)
            case "blue0.4":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 1.0, opacity: 0.4)
            case "blue0.2":
                self.init(.sRGB, red: 0.0, green: 0.0, blue: 1.0, opacity: 0.2)

            // purple 0.5f, 0.0f, 0.5f
            case "purple1.0":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.5, opacity: 1.0)
            case "purple0.8":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.5, opacity: 0.8)
            case "purple0.6":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.5, opacity: 0.6)
            case "purple0.4":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.5, opacity: 0.4)
            case "purple0.2":
                self.init(.sRGB, red: 0.5, green: 0.0, blue: 0.5, opacity: 0.2)

            // fuchsia 1.0f, 0.0f, 1.0f
            case "fuchsia1.0":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0, opacity: 1.0)
            case "fuchsia0.8":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0, opacity: 0.8)
            case "fuchsia0.6":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0, opacity: 0.6)
            case "fuchsia0.4":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0, opacity: 0.4)
            case "fuchsia0.2":
                self.init(.sRGB, red: 1.0, green: 0.0, blue: 1.0, opacity: 0.2)

            default:
                self = .clear
            }
        }
    }

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)

        return (r, g, b, o)
    }
}
