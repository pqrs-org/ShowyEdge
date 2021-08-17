import SwiftUI

struct PreferencesIndicatorView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            GroupBox(label: Text("Height")) {
                HStack {
                    Text("Indicator Height")

                    DoubleTextField(value: $userSettings.indicatorHeightPx,
                                    range: 0 ... 10000,
                                    step: 5,
                                    width: 50)

                    Text("pt")

                    Text("(Default: 5pt)")

                    Spacer()
                }.padding()
            }

            GroupBox(label: Text("Opacity")) {
                HStack {
                    Slider(
                        value: $userSettings.indicatorOpacity,
                        in: 0 ... 100,
                        step: 5,
                        minimumValueLabel: Text("Clear"),
                        maximumValueLabel: Text("Colored (Default)"),
                        label: {
                            Text("")
                        }
                    )
                }.padding()
            }

            GroupBox(label: Text("Options")) {
                VStack(alignment: .leading, spacing: 10.0) {
                    Toggle(isOn: $userSettings.hideInFullScreenSpace) {
                        Text("Hide indicator when full screen (Default: off)")
                        Spacer()
                    }

                    Toggle(isOn: $userSettings.showIndicatorBehindAppWindows) {
                        Text("Show indicator behind app windows (Default: off)")
                        Spacer()
                    }

                    Text("Note: Above options do not work properly when you hide the menu bar.")
                }.padding()
            }

            GroupBox(label: Text("Colors Layout Orientation")) {
                HStack(spacing: 25.0) {
                    Picker(selection: $userSettings.colorsLayoutOrientation, label: Text("")) {
                        Text("Horizontal (Default)").tag("horizontal")
                        Text("Vertical").tag("vertical")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)

                    Spacer()
                }.padding()
            }

            Spacer()
        }.padding()
    }
}

struct PreferencesIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesIndicatorView()
            .previewLayout(.sizeThatFits)
    }
}
