#import "SharedUtilities.h"

@implementation SharedUtilities

+ (BOOL)confirmQuit {
  NSAlert* alert = [NSAlert new];
  alert.messageText = @"Confirmation";
  alert.informativeText = @"Are you sure you want to quit ShowyEdge?";
  [alert addButtonWithTitle:@"Quit"];
  [alert addButtonWithTitle:@"Cancel"];
  return [alert runModal] == NSAlertFirstButtonReturn;
}

@end
