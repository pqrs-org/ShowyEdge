#import "ServerForUserspace.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "PreferencesModel.h"
#import "ServerController.h"
#import "SharedKeys.h"
#import "Updater.h"
#import "WorkSpaceData.h"
#import "weakify.h"

@interface ServerForUserspace ()

@property(weak) IBOutlet PreferencesManager* preferencesManager;
@property(weak) IBOutlet PreferencesModel* preferencesModel;
@property(weak) IBOutlet ServerController* serverController;
@property(weak) IBOutlet Updater* updater;
@property(weak) IBOutlet WorkSpaceData* workSpaceData;

@property NSConnection* connection;

@end

@implementation ServerForUserspace

- (instancetype)init {
  self = [super init];

  if (self) {
    _connection = [NSConnection new];
  }

  return self;
}

- (BOOL)registerService {
  [self.connection setRootObject:self];
  if (![self.connection registerName:kShowyEdgeConnectionName]) {
    return NO;
  }
  return YES;
}

// ----------------------------------------------------------------------
#define ASYNC_RUN_IN_MAIN_QUEUE(CODE)                                              \
  {                                                                                \
    @weakify(self);                                                                \
                                                                                   \
    /* We have to use main queue for [PreferencesManager savePreferencesModel]. */ \
    dispatch_async(dispatch_get_main_queue(), ^{                                   \
      @strongify(self);                                                            \
      if (!self) return;                                                           \
                                                                                   \
      CODE;                                                                        \
    });                                                                            \
  }

- (NSString*)bundleVersion {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (NSString*)currentInputSourceID {
  return self.workSpaceData.currentInputSourceID;
}

- (NSString*)currentInputModeID {
  return self.workSpaceData.currentInputModeID;
}

- (void)savePreferencesModel:(bycopy PreferencesModel*)preferencesModel processIdentifier:(int)processIdentifier {
  // We have to use main queue for [PreferencesManager savePreferencesModel].
  ASYNC_RUN_IN_MAIN_QUEUE(
      [self.preferencesManager savePreferencesModel:preferencesModel
                                  processIdentifier:processIdentifier]);
}

- (void)updateStartAtLogin {
  ASYNC_RUN_IN_MAIN_QUEUE(
      [self.serverController updateStartAtLogin:YES]);
}

- (void)terminateServerProcess {
  ASYNC_RUN_IN_MAIN_QUEUE(
      [self.serverController terminateServerProcess]);
}

- (void)checkForUpdatesStableOnly {
  ASYNC_RUN_IN_MAIN_QUEUE(
      [self.updater checkForUpdatesStableOnly]);
}

- (void)checkForUpdatesWithBetaVersion {
  ASYNC_RUN_IN_MAIN_QUEUE(
      [self.updater checkForUpdatesWithBetaVersion]);
}

@end
