class IndicatorView: NSView {
    public var color0: NSColor?
    public var color1: NSColor?
    public var color2: NSColor?

    let adjustHeight: CGFloat = 2.0

    override func draw(_: NSRect) {
        if let color0 = self.color0,
           let color1 = self.color1,
           let color2 = self.color2
        {
            let orientation = UserSettings.shared.colorsLayoutOrientation
            let isColorsLayoutOrientationHorizontal = (orientation == "horizontal")

            if isColorsLayoutOrientationHorizontal {
                let width = frame.width / 3

                color0.set()
                NSRect(x: width * 0, y: 0, width: width, height: frame.height).fill()

                color1.set()
                NSRect(x: width * 1, y: 0, width: width, height: frame.height).fill()

                color2.set()
                NSRect(x: width * 2, y: 0, width: width, height: frame.height).fill()
            } else {
                let height = (frame.height - adjustHeight) / 3

                color2.set()
                NSRect(x: 0, y: height * 0, width: frame.width, height: height).fill()

                color1.set()
                NSRect(x: 0, y: height * 1, width: frame.width, height: height).fill()

                color0.set()
                NSRect(x: 0, y: height * 2, width: frame.width, height: height).fill()
            }
        }
    }

    public func setColors(_ colors: (NSColor, NSColor, NSColor)) {
        var opacity = CGFloat(UserSettings.shared.indicatorOpacity) / 100

        // If indicator size is too large, set transparency in order to avoid the indicator hides all windows.
        let threshold = CGFloat(100)
        if frame.width > threshold,
           frame.height > threshold
        {
            let maxOpacity: CGFloat = 0.8
            if opacity > maxOpacity {
                opacity = maxOpacity
            }
        }

        color0 = colors.0.withAlphaComponent(opacity * colors.0.alphaComponent)
        color1 = colors.1.withAlphaComponent(opacity * colors.1.alphaComponent)
        color2 = colors.2.withAlphaComponent(opacity * colors.2.alphaComponent)
        display()
    }
}
