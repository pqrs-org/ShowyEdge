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

- (CGFloat)indicatorHeight {
  CGFloat height = [[NSApp mainMenu] menuBarHeight];
  CGFloat factor = [[[NSUserDefaults standardUserDefaults] stringForKey:kIndicatorHeight] floatValue];
  height *= factor;

  NSRect rect = [[NSScreen mainScreen] frame];
  if (height > rect.size.height) {
    height = rect.size.height;
  }

  return height;
}

@end
