#import "PreferencesKeys.h"
#import "PreferencesModel.h"
#import "ServerForUserspace.h"
#import "SharedKeys.h"
#import "WorkSpaceData.h"

@interface ServerForUserspace ()

@property IBOutlet WorkSpaceData* workSpaceData;

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
- (NSString*)currentInputSourceID {
  return self.workSpaceData.currentInputSourceID;
}

- (NSString*)currentInputModeID {
  return self.workSpaceData.currentInputModeID;
}

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel {
  preferencesModel.customFrameTop = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameTop];
}

- (void)savePreferencesModel:(PreferencesModel*)preferencesModel {
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameTop) forKey:kCustomFrameTop];
}

@end
