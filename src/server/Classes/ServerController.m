#import "ServerController.h"
#import "PreferencesKeys.h"
#import "PreferencesModel.h"
#import "StartAtLoginUtilities.h"

@interface ServerController ()

@property(weak) IBOutlet PreferencesModel* preferencesModel;

@end

@implementation ServerController

- (BOOL)confirmQuit {
  NSAlert* alert = [NSAlert new];
  alert.messageText = @"Confirmation";
  alert.informativeText = @"Are you sure you want to quit ShowyEdge?";
  [alert addButtonWithTitle:@"Quit"];
  [alert addButtonWithTitle:@"Cancel"];
  return [alert runModal] == NSAlertFirstButtonReturn;
}

- (void)terminateServerProcess {
  [self updateStartAtLogin:NO];
  [NSApp terminate:nil];
}

- (BOOL)isDebuggingBundle {
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

- (void)updateStartAtLogin:(BOOL)preferredValue {
  NSLog(@"updateStartAtLogin");
  if (!preferredValue) {
    [StartAtLoginUtilities setStartAtLogin:NO];

  } else {
    // Do not register to StartAtLogin if kResumeAtLogin is NO.
    if (!self.preferencesModel.resumeAtLogin || [self isDebuggingBundle]) {
      [StartAtLoginUtilities setStartAtLogin:NO];
    } else {
      [StartAtLoginUtilities setStartAtLogin:YES];
    }
  }
}

@end
