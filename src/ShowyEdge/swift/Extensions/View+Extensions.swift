import SwiftUI

extension View {
  // https://gist.github.com/importRyan/c668904b0c5442b80b6f38a980595031
  func whenHovered(_ mouseIsInside: @escaping (Bool) -> Void) -> some View {
    modifier(MouseInsideModifier(mouseIsInside))
  }
}
