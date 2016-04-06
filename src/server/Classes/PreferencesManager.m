#import "PreferencesManager.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesModel.h"
#import "ServerController.h"
#import "SharedKeys.h"

@interface PreferencesManager ()

@property(weak) IBOutlet PreferencesModel* preferencesModel;
@property(weak) IBOutlet ServerController* serverController;

@end

@implementation PreferencesManager

+ (void)initialize {
  NSDictionary* dict = @{
    kIndicatorHeight : @"0.15",
    kIndicatorOpacity : @100,
    kShowIconInDock : @NO,
    kResumeAtLogin : @YES,
    kUseCustomFrame : @NO,
    kCustomFrameTop : @0,
    kCustomFrameLeft : @0,
    kCustomFrameWidth : @100,
    kCustomFrameHeight : @100,
    kColorsLayoutOrientation : @"horizontal",
  };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel {
  preferencesModel.resumeAtLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kResumeAtLogin];
  preferencesModel.checkForUpdates = YES;

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

  // ----------------------------------------
  if (preferencesModel != self.preferencesModel) {
    [self loadPreferencesModel:self.preferencesModel];
  }
  [self.serverController updateStartAtLogin:YES];

  // ----------------------------------------
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kShowyEdgePreferencesUpdatedNotification object:nil];
}

@end
