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
  preferencesModel.resumeAtLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kResumeAtLogin];

  preferencesModel.inputSourceColors = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor];

  preferencesModel.indicatorHeight = [[NSUserDefaults standardUserDefaults] floatForKey:kIndicatorHeight];
  preferencesModel.indicatorOpacity = [[NSUserDefaults standardUserDefaults] integerForKey:kIndicatorOpacity];
  preferencesModel.colorsLayoutOrientation = [[NSUserDefaults standardUserDefaults] stringForKey:kColorsLayoutOrientation];

  preferencesModel.useCustomFrame = [[NSUserDefaults standardUserDefaults] boolForKey:kUseCustomFrame];
  preferencesModel.customFrameLeft = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameLeft];
  preferencesModel.customFrameTop = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameTop];
  preferencesModel.customFrameWidth = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameWidth];
  preferencesModel.customFrameHeight = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameHeight];
}

- (void)savePreferencesModel:(PreferencesModel*)preferencesModel {
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.resumeAtLogin) forKey:kResumeAtLogin];

  [[NSUserDefaults standardUserDefaults] setObject:preferencesModel.inputSourceColors forKey:kCustomizedLanguageColor];

  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.indicatorHeight) forKey:kIndicatorHeight];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.indicatorOpacity) forKey:kIndicatorOpacity];
  [[NSUserDefaults standardUserDefaults] setObject:preferencesModel.colorsLayoutOrientation forKey:kColorsLayoutOrientation];

  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.useCustomFrame) forKey:kUseCustomFrame];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameLeft) forKey:kCustomFrameLeft];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameTop) forKey:kCustomFrameTop];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameWidth) forKey:kCustomFrameWidth];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameHeight) forKey:kCustomFrameHeight];
}

@end
