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
            let orientation = PreferencesManager.colorsLayoutOrientation()
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

    public func setColor(_ c0: NSColor, _ c1: NSColor, _ c2: NSColor) {
        var opacity = UserSettings.shared.indicatorOpacity / 100

        // If indicator size is too large, set transparency in order to avoid the indicator hides all windows.
        let menuBarHeight = PreferencesManager.indicatorHeightPx()
        if frame.width > menuBarHeight,
           frame.height > menuBarHeight
        {
            let maxOpacity: CGFloat = 0.8
            if opacity > maxOpacity {
                opacity = maxOpacity
            }
        }

        color0 = c0.withAlphaComponent(opacity * c0.alphaComponent)
        color1 = c1.withAlphaComponent(opacity * c1.alphaComponent)
        color2 = c2.withAlphaComponent(opacity * c2.alphaComponent)
        display()
    }
}
