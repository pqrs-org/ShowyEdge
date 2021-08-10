import SwiftUI

struct PreferencesIndicatorView: View {
    @ObservedObject var userSettings = UserSettings.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            GroupBox(label: Text("Opacity")) {
                VStack(alignment: .leading, spacing: 25.0) {
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
                    }

                    Toggle(isOn: $userSettings.showIndicatorBehindAppWindows) {
                        Text("Show indicator behind app windows (Default: off)")
                    }

                    Text("Note: Above options do not work properly when you hide the menu bar.")
                }.padding()
            }

            GroupBox(label: Text("Colors layout orientation")) {
                VStack(alignment: .leading, spacing: 25.0) {
                    Picker(selection: $userSettings.colorsLayoutOrientation, label: Text("")) {
                        Text("Horizontal (Default)").tag("horizontal")
                        Text("Vertical").tag("vertical")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)
                }
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
