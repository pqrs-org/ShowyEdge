#import "LanguageColorTableViewController.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesWindowController.h"
#import "Relauncher.h"
#import "ServerController.h"
#import "ServerObjects.h"
#import "Updater.h"
#import "WorkSpaceData.h"

@interface PreferencesWindowController ()

@property(weak) IBOutlet LanguageColorTableViewController* languageColorTableViewController;
@property(weak) IBOutlet NSTextField* currentInputSourceID;
@property(weak) IBOutlet NSTextField* versionText;

@end

@implementation PreferencesWindowController

- (void)observer_kCurrentInputSourceIDChangedNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.serverObjects.workSpaceData.currentInputSourceID length] > 0) {
      [self.currentInputSourceID setStringValue:self.serverObjects.workSpaceData.currentInputSourceID];
    }
  });
}

- (instancetype)initWithServerObjects:(NSString*)windowNibName serverObjects:(ServerObjects*)serverObjects {
  self = [super initWithWindowNibName:windowNibName];

  if (self) {
    self.serverObjects = serverObjects;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observer_kCurrentInputSourceIDChangedNotification:)
                                                 name:kCurrentInputSourceIDChangedNotification
                                               object:nil];

    [self observer_kCurrentInputSourceIDChangedNotification:nil];

    // Show icon in Dock only when Preferences has been opened.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kShowIconInDock]) {
      ProcessSerialNumber psn = {0, kCurrentProcess};
      TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    }
  }

  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawVersion {
  NSString* version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
  [self.versionText setStringValue:version];
}

- (void)windowDidBecomeMain:(NSNotification*)notification {
  [self drawVersion];
}

- (void)show {
  [self.window makeKeyAndOrderFront:self];
  [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)add:(id)sender {
  if ([self.serverObjects.workSpaceData.currentInputSourceID length] > 0) {
    [self.languageColorTableViewController add:self.serverObjects.workSpaceData.currentInputSourceID];
  }
}

- (IBAction)remove:(id)sender {
  [self.languageColorTableViewController remove];
}

- (IBAction)quit:(id)sender {
  [ServerController quitWithConfirmation];
}

- (IBAction)checkForUpdatesStableOnly:(id)sender {
  [self.serverObjects.updater checkForUpdatesStableOnly];
}

- (IBAction)checkForUpdatesWithBetaVersion:(id)sender {
  [self.serverObjects.updater checkForUpdatesWithBetaVersion];
}

- (IBAction)openURL:(id)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}

- (IBAction)updateStartAtLogin:(id)sender {
  [ServerController updateStartAtLogin:YES];
}

- (IBAction)relaunch:(id)sender {
  [Relauncher relaunch];
}

@end
