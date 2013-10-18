#import "NotificationKeys.h"
#import "PreferencesController.h"
#import "PreferencesKeys.h"
#import "StartAtLoginController.h"

@implementation PreferencesController

+ (void) initialize
{
  NSDictionary* dict = @{
    kIndicatorHeight: @"0.25",
    kIndicatorOpacity: @50,
    kShowIconInDock: @NO,
    kUseCustomFrame: @NO,
    kCustomFrameTop: @0,
    kCustomFrameLeft: @0,
    kCustomFrameWidth: @100,
    kCustomFrameHeight: @100,
  };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void) load
{
  if ([StartAtLoginController isStartAtLogin]) {
    [self.startAtLogin setState:NSOnState];
  } else {
    [self.startAtLogin setState:NSOffState];
  }

  [self.version setStringValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
}

- (IBAction) toggleStartAtLogin:(id)sender
{
  if ([StartAtLoginController isStartAtLogin]) {
    [StartAtLoginController setStartAtLogin:NO];
  } else {
    [StartAtLoginController setStartAtLogin:YES];
  }
}

- (IBAction) indicatorHeightChanged:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kIndicatorHeightChangedNotification object:nil];
}

+ (CGFloat) indicatorHeight
{
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
