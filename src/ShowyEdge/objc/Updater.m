#ifdef USE_SPARKLE
@import Sparkle;
#endif

#import "Updater.h"

@interface Updater ()

#ifdef USE_SPARKLE
@property SUUpdater* suupdater;
#endif

@end

@implementation Updater

- (instancetype)init {
  self = [super init];

  if (self) {
#ifdef USE_SPARKLE
    self.suupdater = [SUUpdater new];
#endif
  }

  return self;
}

- (NSString*)getFeedURL:(BOOL)includingBetaVersions {
  // ----------------------------------------
  // check beta & stable releases.

  // Once we check appcast.xml, SUFeedURL is stored in a user's preference file.
  // So that Sparkle gives priority to a preference over Info.plist,
  // we overwrite SUFeedURL here.
  if (includingBetaVersions) {
    return @"https://appcast.pqrs.org/showyedge-appcast-devel.xml";
  }

  return @"https://appcast.pqrs.org/showyedge-appcast.xml";
}

- (void)check:(BOOL)isBackground {
#ifdef USE_SPARKLE
  NSString* url = [self getFeedURL:NO];
  [self.suupdater setFeedURL:[NSURL URLWithString:url]];

  NSLog(@"checkForUpdates %@", url);
  if (isBackground) {
    [self.suupdater checkForUpdatesInBackground];
  } else {
    [self.suupdater checkForUpdates:nil];
  }
#endif
}

- (void)checkForUpdatesInBackground {
  [self check:YES];
}

- (void)checkForUpdatesStableOnly {
#ifdef USE_SPARKLE
  NSString* url = [self getFeedURL:NO];
  [self.suupdater setFeedURL:[NSURL URLWithString:url]];
  NSLog(@"checkForUpdates %@", url);
  [self.suupdater checkForUpdates:nil];
#endif
}

- (void)checkForUpdatesWithBetaVersion {
#ifdef USE_SPARKLE
  NSString* url = [self getFeedURL:YES];
  [self.suupdater setFeedURL:[NSURL URLWithString:url]];
  NSLog(@"checkForUpdates %@", url);
  [self.suupdater checkForUpdates:nil];
#endif
}

@end
