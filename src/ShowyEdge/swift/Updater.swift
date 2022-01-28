import Foundation

#if USE_SPARKLE
  import Sparkle
#endif

final class Updater: ObservableObject {
  static let shared = Updater()

  #if USE_SPARKLE
    private let updaterController: SPUStandardUpdaterController
    private let delegate = SparkleDelegate()
  #endif

  @Published var canCheckForUpdates = false

  init() {
    #if USE_SPARKLE
      updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: delegate,
        userDriverDelegate: nil
      )

      updaterController.updater.publisher(for: \.canCheckForUpdates)
        .assign(to: &$canCheckForUpdates)
    #endif
  }

  func checkForUpdatesInBackground() {
    #if USE_SPARKLE
      delegate.includingBetaVersions = false
      updaterController.updater.checkForUpdatesInBackground()
    #endif
  }

  func checkForUpdatesStableOnly() {
    #if USE_SPARKLE
      delegate.includingBetaVersions = false
      updaterController.checkForUpdates(nil)
    #endif
  }

  func checkForUpdatesWithBetaVersion() {
    #if USE_SPARKLE
      delegate.includingBetaVersions = true
      updaterController.checkForUpdates(nil)
    #endif
  }

  #if USE_SPARKLE
    private class SparkleDelegate: NSObject, SPUUpdaterDelegate,
      SPUStandardUserDriverDelegate
    {
      var includingBetaVersions = false

      func feedURLString(for updater: SPUUpdater) -> String? {
        var url = "https://appcast.pqrs.org/showyedge-appcast.xml"
        if includingBetaVersions {
          url = "https://appcast.pqrs.org/showyedge-appcast-devel.xml"
        }

        print("feedURLString \(url)")

        return url
      }
    }
  #endif
}
