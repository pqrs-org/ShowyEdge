import Foundation

#if USE_SPARKLE
  import Sparkle
#endif

struct Updater {
  static func checkForUpdatesInBackground() {
    #if USE_SPARKLE
      let url = feedURL(false)
      print("checkForUpdates \(url)")
      SUUpdater.shared().feedURL = url
      SUUpdater.shared()?.checkForUpdatesInBackground()
    #endif
  }

  static func checkForUpdatesStableOnly() {
    #if USE_SPARKLE
      let url = feedURL(false)
      print("checkForUpdates \(url)")
      SUUpdater.shared().feedURL = url
      SUUpdater.shared()?.checkForUpdates(self)
    #endif
  }

  static func checkForUpdatesWithBetaVersion() {
    #if USE_SPARKLE
      let url = feedURL(true)
      print("checkForUpdates \(url)")
      SUUpdater.shared().feedURL = url
      SUUpdater.shared()?.checkForUpdates(self)
    #endif
  }

  private static func feedURL(_ includingBetaVersions: Bool) -> URL {
    if includingBetaVersions {
      return URL(string: "https://appcast.pqrs.org/showyedge-appcast-devel.xml")!
    }
    return URL(string: "https://appcast.pqrs.org/showyedge-appcast.xml")!
  }
}
