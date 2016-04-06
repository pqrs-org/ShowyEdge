#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "ServerController.h"
#import "ServerForUserspace.h"
#import "SharedKeys.h"
#import "Updater.h"
#import "WorkSpaceData.h"

@interface ServerForUserspace ()

@property IBOutlet WorkSpaceData* workSpaceData;
@property IBOutlet Updater* updater;

@property NSConnection* connection;

@end

@implementation ServerForUserspace

- (id)init {
  self = [super init];

  if (self) {
    self.connection = [NSConnection new];
  }

  return self;
}

- (BOOL) register {
  [self.connection setRootObject:self];
  if (![self.connection registerName:kShowyEdgeConnectionName]) {
    return NO;
  }
  return YES;
}

// ----------------------------------------------------------------------
- (NSString*)bundleVersion {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (NSString*)currentInputSourceID {
  return self.workSpaceData.currentInputSourceID;
}

- (NSString*)currentInputModeID {
  return self.workSpaceData.currentInputModeID;
}

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel {
  [PreferencesManager loadPreferencesModel:preferencesModel];
}

- (void)savePreferencesModel:(PreferencesModel*)preferencesModel {
  [PreferencesManager savePreferencesModel:preferencesModel];
}

- (BOOL)confirmQuit {
  __block BOOL quit = NO;
  dispatch_sync(dispatch_get_main_queue(), ^{
    quit = [ServerController confirmQuit];
  });
  return quit;
}

- (void)terminateServerProcess {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [ServerController terminateServerProcess];
  });
}

- (void)checkForUpdatesStableOnly {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [self.updater checkForUpdatesStableOnly];
  });
}

- (void)checkForUpdatesWithBetaVersion {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [self.updater checkForUpdatesWithBetaVersion];
  });
}

@end
