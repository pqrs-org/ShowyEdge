import SwiftUI

struct CustomFrameUnitPicker: View {
    @Binding var value: Int

    var body: some View {
        Picker(selection: $value, label: Text("")) {
            Text("pt").tag(0)
            Text("%").tag(1)
        }.frame(width: 60.0)
    }
}
