#import "NotificationKeys.h"
#import "PreferencesController.h"
#import "PreferencesKeys.h"
#import "StartAtLoginController.h"

@implementation PreferencesController

+ (void) initialize
{
  NSDictionary* dict = @{ kIndicatorHeight : @"0.25" };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void) load
{
  if ([StartAtLoginController isStartAtLogin]) {
    [startAtLogin_ setState:NSOnState];
  } else {
    [startAtLogin_ setState:NSOffState];
  }

  [version_ setStringValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (IBAction) setStartAtLogin:(id)sender
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
