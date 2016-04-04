#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "ServerForUserspace.h"
#import "SharedKeys.h"
#import "WorkSpaceData.h"

@interface ServerForUserspace ()

@property IBOutlet WorkSpaceData* workSpaceData;
@property IBOutlet PreferencesManager* preferencesManager;

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
  [self.preferencesManager loadPreferencesModel:preferencesModel];
}

- (void)savePreferencesModel:(PreferencesModel*)preferencesModel {
  [self.preferencesManager savePreferencesModel:preferencesModel];
}

@end
