#import "PreferencesController.h"
#import "StartAtLoginController.h"

@implementation PreferencesController

static NSString* indicatorShapes_[] = { @"thin", @"menuheight", @"fullscreen", nil };

- (void) load
{
  if ([StartAtLoginController isStartAtLogin]) {
    [startAtLogin_ setState:NSOnState];
  } else {
    [startAtLogin_ setState:NSOffState];
  }

  if ([PreferencesController isHideIconInDock]) {
    [hideIconInDock_ setState:NSOnState];
  } else {
    [hideIconInDock_ setState:NSOffState];
  }

  [indicatorShape_ selectItemAtIndex:0];
  NSString* shape = [PreferencesController indicatorShape];
  for (NSInteger i = 0;; ++i) {
    NSString* s = indicatorShapes_[i];
    if (! s) break;

    if ([shape isEqualToString:s]) {
      [indicatorShape_ selectItemAtIndex:i];
    }
  }
}

- (IBAction) setStartAtLogin:(id)sender
{
  // startAtLogin
  if ([StartAtLoginController isStartAtLogin]) {
    [StartAtLoginController setStartAtLogin:NO];
  } else {
    [StartAtLoginController setStartAtLogin:YES];
  }
}

- (IBAction) setHideIconInDock:(id)sender
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString* key = @"hideIconInDock";

  if ([hideIconInDock_ state] == NSOnState) {
    [defaults setBool:YES forKey:key];
  } else {
    [defaults setBool:NO forKey:key];
  }
}

- (IBAction) setIndicatorShape:(id)sender
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString* key = @"indicatorShape";

  NSString* value = indicatorShapes_[[indicatorShape_ indexOfSelectedItem]];
  // NSLog(@"%@", value);
  [defaults setObject:value forKey:key];

  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"updateIndicatorShape" object:nil userInfo:nil]];
}

+ (BOOL) isHideIconInDock
{
  // Default value is NO.
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideIconInDock"];
}

+ (NSString*) indicatorShape
{
  NSString* shape = [[NSUserDefaults standardUserDefaults] objectForKey:@"indicatorShape"];
  if (! shape) {
    shape = @"thin";
  }
  return shape;
}

+ (CGFloat) indicatorWidth
{
  NSRect rect = [[NSScreen mainScreen] frame];
  CGFloat width = rect.size.width;

  NSString* shape = [PreferencesController indicatorShape];
  if ([shape isEqualToString:@"menuheight"]) {
    width /= 2;
  }

  return width;
}

+ (CGFloat) indicatorHeight
{
  CGFloat height = [[NSApp mainMenu] menuBarHeight];

  NSString* shape = [PreferencesController indicatorShape];
  if ([shape isEqualToString:@"thin"]) {
    height /= 4;
  } else if ([shape isEqualToString:@"menuheight"]) {
    height -= 1;
  } else if ([shape isEqualToString:@"fullscreen"]) {
    NSRect rect = [[NSScreen mainScreen] frame];
    height = rect.size.height;
  }

  return height;
}

@end
