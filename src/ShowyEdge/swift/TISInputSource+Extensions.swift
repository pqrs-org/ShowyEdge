import Carbon

extension TISInputSource {
  private func getProperty(_ key: CFString) -> AnyObject? {
    guard let cfType = TISGetInputSourceProperty(self, key) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(cfType).takeUnretainedValue()
  }

  var inputSourceID: String? {
    return getProperty(kTISPropertyInputSourceID) as? String
  }

  var inputModeID: String? {
     return getProperty(kTISPropertyInputModeID) as? String
  }
}
