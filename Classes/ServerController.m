#import "PreferencesKeys.h"
#import "ServerController.h"
#import "StartAtLoginUtilities.h"

@implementation ServerController

+ (void)quitWithConfirmation {
  NSAlert* alert = [NSAlert new];
  alert.messageText = @"Confirmation";
  alert.informativeText = @"Are you sure you want to quit ShowyEdge?";
  [alert addButtonWithTitle:@"Quit"];
  [alert addButtonWithTitle:@"Cancel"];
  if ([alert runModal] != NSAlertFirstButtonReturn) {
    return;
  }

  [ServerController updateStartAtLogin:NO];
  [NSApp terminate:nil];
}

+ (void)updateStartAtLogin:(BOOL)preferredValue {
  [StartAtLoginUtilities setStartAtLogin:preferredValue];
}

@end
