#import "PreferencesKeys.h"
#import "PreferencesManager.h"

@implementation PreferencesManager

+ (void)initialize {
  NSDictionary* dict = @{
    kIndicatorHeight : @"0.25",
    kIndicatorOpacity : @50,
    kShowIconInDock : @NO,
    kUseCustomFrame : @NO,
    kCustomFrameTop : @0,
    kCustomFrameLeft : @0,
    kCustomFrameWidth : @100,
    kCustomFrameHeight : @100,
    kColorsLayoutOrientation : @"horizontal",
  };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (BOOL)isCheckForUpdates {
  return YES;
}

@end
