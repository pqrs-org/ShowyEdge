// -*- mode: objective-c -*-

@import Cocoa;

@interface Updater : NSObject

- (void)checkForUpdatesInBackground;
- (void)checkForUpdatesStableOnly;
- (void)checkForUpdatesWithBetaVersion;

@end
