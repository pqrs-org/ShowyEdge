import Carbon
import Foundation

private struct InputSource {
  let id: String
  let localizedName: String
  let languages: [String]
}

private func getProperty(_ inputSource: TISInputSource, _ key: CFString) -> AnyObject? {
  guard let cfType = TISGetInputSourceProperty(inputSource, key) else {
    return nil
  }

  return Unmanaged<AnyObject>.fromOpaque(cfType).takeUnretainedValue()
}

private func usage() {
  print(
    """
    Usage: dump-input-sources [--all-installed]

      --all-installed  Include all installed input sources instead of enabled input sources.
      --help           Show this help.
    """)
}

private let arguments = CommandLine.arguments.dropFirst()

if arguments.contains("--help") {
  usage()
  exit(0)
}

private let knownArguments: Set<String> = [
  "--all-installed",
]

private let unknownArguments = arguments.filter { !knownArguments.contains($0) }
if !unknownArguments.isEmpty {
  fputs("Unknown argument: \(unknownArguments.joined(separator: ", "))\n\n", stderr)
  usage()
  exit(1)
}

private let includeAllInstalled = arguments.contains("--all-installed")

guard
  let inputSources = TISCreateInputSourceList(nil, includeAllInstalled)?.takeRetainedValue()
    as? [TISInputSource]
else {
  fputs("Failed to get input sources.\n", stderr)
  exit(1)
}

private let sources = inputSources.map { inputSource in
  InputSource(
    id: getProperty(inputSource, kTISPropertyInputSourceID) as? String ?? "",
    localizedName: getProperty(inputSource, kTISPropertyLocalizedName) as? String ?? "",
    languages: getProperty(inputSource, kTISPropertyInputSourceLanguages) as? [String] ?? []
  )
}

print("includeAllInstalled: \(includeAllInstalled)")
print("count: \(sources.count)")

for source in sources {
  print("")
  print("id: \(source.id)")
  print("localizedName: \(source.localizedName)")
  print("languages: \(source.languages)")
}
