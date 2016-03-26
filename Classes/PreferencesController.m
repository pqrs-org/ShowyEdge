#import "NotificationKeys.h"
#import "PreferencesController.h"
#import "PreferencesKeys.h"
#import "StartAtLoginUtilities.h"

@implementation PreferencesController

- (void)load {
  if ([StartAtLoginUtilities isStartAtLogin]) {
    [self.startAtLogin setState:NSOnState];
  } else {
    [self.startAtLogin setState:NSOffState];
  }

  [self.version setStringValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
}

- (IBAction)toggleStartAtLogin:(id)sender {
  if ([StartAtLoginUtilities isStartAtLogin]) {
    [StartAtLoginUtilities setStartAtLogin:NO];
  } else {
    [StartAtLoginUtilities setStartAtLogin:YES];
  }
}

- (IBAction)indicatorHeightChanged:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:kIndicatorHeightChangedNotification object:nil];
}

+ (CGFloat)indicatorHeight {
  CGFloat height = [[NSApp mainMenu] menuBarHeight];
  CGFloat factor = [[[NSUserDefaults standardUserDefaults] stringForKey:kIndicatorHeight] floatValue];
  height *= factor;

  NSRect rect = [[NSScreen mainScreen] frame];
  if (height > rect.size.height) {
    height = rect.size.height;
  }

  return height;
}

- (IBAction)openURL:(id)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}

@end
