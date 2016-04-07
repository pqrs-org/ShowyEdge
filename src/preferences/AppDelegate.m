#import "AppDelegate.h"
#import "NotificationKeys.h"
#import "PreferencesModel.h"
#import "PreferencesWindowController.h"
#import "ServerClient.h"

@interface AppDelegate ()

@property(weak) IBOutlet PreferencesModel* preferencesModel;
@property(weak) IBOutlet ServerClient* client;
@property(weak) IBOutlet PreferencesWindowController* preferencesWindowController;

@end

@implementation AppDelegate

// ------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
  if ([[self.client proxy].bundleVersion length] == 0) {
    NSAlert* alert = [NSAlert new];
    [alert setMessageText:@"ShowyEdge Alert"];
    [alert addButtonWithTitle:@"Close"];
    [alert setInformativeText:@"ShowyEdge server is not running."];
    [alert runModal];

    [NSApp terminate:self];
  }

  [[self.client proxy] loadPreferencesModel:self.preferencesModel];

  [self.preferencesWindowController setup];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication {
  return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication*)theApplication hasVisibleWindows:(BOOL)flag {
  [self.preferencesWindowController show];
  return YES;
}

@end
