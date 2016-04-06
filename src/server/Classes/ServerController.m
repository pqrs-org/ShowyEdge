#import "PreferencesKeys.h"
#import "ServerController.h"
#import "StartAtLoginUtilities.h"

@implementation ServerController

+ (BOOL)quitWithConfirmation {
  NSAlert* alert = [NSAlert new];
  alert.messageText = @"Confirmation";
  alert.informativeText = @"Are you sure you want to quit ShowyEdge?";
  [alert addButtonWithTitle:@"Quit"];
  [alert addButtonWithTitle:@"Cancel"];
  if ([alert runModal] != NSAlertFirstButtonReturn) {
    return NO;
  }

  [ServerController updateStartAtLogin:NO];
  [NSApp terminate:nil];
  return YES;
}

+ (BOOL)isDebuggingBundle {
  NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
  if ([bundlePath length] > 0) {
    if ([bundlePath hasSuffix:@"/Build/Products/Release/ShowyEdge.app"] /* from Xcode */ ||
        [bundlePath hasSuffix:@"/build/Release/ShowyEdge.app"] /* from command line */) {
      NSLog(@"%@ is debugging bundle", bundlePath);
      return YES;
    }
  }
  return NO;
}

+ (void)updateStartAtLogin:(BOOL)preferredValue {
  NSLog(@"updateStartAtLogin");
  if (!preferredValue) {
    [StartAtLoginUtilities setStartAtLogin:NO];

  } else {
    // Do not register to StartAtLogin if kResumeAtLogin is NO.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kResumeAtLogin] || [ServerController isDebuggingBundle]) {
      [StartAtLoginUtilities setStartAtLogin:NO];
    } else {
      [StartAtLoginUtilities setStartAtLogin:YES];
    }
  }
}

@end
