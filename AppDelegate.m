#import "AppDelegate.h"
#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "PreferencesWindowController.h"
#import "Relauncher.h"
#import "ServerController.h"
#import "ServerObjects.h"
#import "StartAtLoginUtilities.h"
#import "Updater.h"
#import "WorkSpaceData.h"

@interface AppDelegate () {
  NSMutableArray* windows_;
}

@property(weak) IBOutlet PreferencesManager* preferencesManager;
@property(weak) IBOutlet ServerObjects* serverObjects;
@property(weak) IBOutlet Updater* updater;

@property PreferencesWindowController* preferencesWindowController;

@end

@implementation AppDelegate

- (void)observer_NSWorkspaceDidActivateApplicationNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];
  });
}

- (void)observer_kCurrentInputSourceIDChangedNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];

    // ------------------------------------------------------------
    NSString* inputsourceid = self.serverObjects.workSpaceData.currentInputSourceID;
    if ([inputsourceid length] == 0) {
      inputsourceid = @"org.pqrs.inputsourceid.unknown";
    }
    // NSLog(@"%@", inputsourceid);

    // ------------------------------------------------------------
    // check customized language color
    NSArray* colors = [self.preferencesManager getColorsFromInputSourceID:inputsourceid];
    if (colors) {
      [self setColor:colors[0] c1:colors[1] c2:colors[2]];
      return;
    }

    // ------------------------------------------------------------
    // default language color
    NSString* inputmodeid = self.serverObjects.workSpaceData.currentInputModeID;

    if ([inputmodeid length] > 0) {
      /*  */ if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.Katakana"]) {
        [self setColor:[NSColor whiteColor] c1:[NSColor greenColor] c2:[NSColor whiteColor]];

      } else if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.HalfWidthKana"]) {
        [self setColor:[NSColor whiteColor] c1:[NSColor purpleColor] c2:[NSColor whiteColor]];

      } else if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.FullWidthRoman"]) {
        [self setColor:[NSColor whiteColor] c1:[NSColor yellowColor] c2:[NSColor whiteColor]];

      } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Japanese"]) {
        [self setColor:[NSColor whiteColor] c1:[NSColor redColor] c2:[NSColor whiteColor]];

      } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.TCIM"]) {
        // TradChinese
        [self setColor:[NSColor redColor] c1:[NSColor redColor] c2:[NSColor redColor]];

      } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.SCIM"]) {
        // SimpChinese
        [self setColor:[NSColor redColor] c1:[NSColor redColor] c2:[NSColor redColor]];

      } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Korean"]) {
        [self setColor:[NSColor redColor] c1:[NSColor blueColor] c2:[NSColor clearColor]];

      } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Roman"]) {
        [self setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];

      } else {
        [self setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];
      }

    } else {
      /*  */ if ([inputsourceid hasPrefix:@"com.apple.keylayout.British"]) {
        [self setColor:[NSColor blueColor] c1:[NSColor redColor] c2:[NSColor blueColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Canadian"]) {
        [self setColor:[NSColor redColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.French"]) {
        [self setColor:[NSColor blueColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.German"]) {
        [self setColor:[NSColor grayColor] c1:[NSColor redColor] c2:[NSColor yellowColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Italian"]) {
        [self setColor:[NSColor greenColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Kazakh"]) {
        [self setColor:[NSColor blueColor] c1:[NSColor yellowColor] c2:[NSColor blueColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Portuguese"]) {
        [self setColor:[NSColor greenColor] c1:[NSColor redColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Russian"]) {
        [self setColor:[NSColor whiteColor] c1:[NSColor blueColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Swedish"]) {
        [self setColor:[NSColor blueColor] c1:[NSColor yellowColor] c2:[NSColor blueColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Spanish"]) {
        [self setColor:[NSColor redColor] c1:[NSColor yellowColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Swiss"]) {
        [self setColor:[NSColor redColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Dvorak"]) {
        [self setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];

      } else if ([inputsourceid hasPrefix:@"com.apple.keyboardlayout.fr-dvorak-bepo.keylayout.FrenchDvorak"]) {
        [self setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];

      } else {
        [self setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];
      }
    }
  });
}

- (void)setupWindows {
  NSArray* screens = [NSScreen screens];

  NSWindowCollectionBehavior behavior = NSWindowCollectionBehaviorCanJoinAllSpaces |
                                        NSWindowCollectionBehaviorStationary |
                                        NSWindowCollectionBehaviorIgnoresCycle;

  NSRect rect = [[NSScreen mainScreen] frame];

  while ([windows_ count] < [screens count]) {
    NSWindow* w = [[NSWindow alloc] initWithContentRect:rect
                                              styleMask:NSBorderlessWindowMask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];

    // Note: Do not set alpha value for window.
    // Window with alpha value causes glitch at switching a space (Mission Control).

    [w setBackgroundColor:[NSColor clearColor]];
    [w setOpaque:NO];
    [w setHasShadow:NO];
    [w setLevel:NSStatusWindowLevel];
    [w setIgnoresMouseEvents:YES];
    [w setCollectionBehavior:behavior];

    [w setContentView:[[MenuBarOverlayView alloc] initWithFrame:rect]];

    [windows_ addObject:w];
  }
}

- (void)adjustFrame {
  [self setupWindows];

  // ----------------------------------------
  NSArray* screens = [NSScreen screens];

  for (NSUInteger i = 0; i < [windows_ count]; ++i) {
    NSWindow* w = windows_[i];
    MenuBarOverlayView* view = [w contentView];

    if (i >= [screens count]) {
      [w orderOut:self];

    } else {
      NSRect rect = [screens[i] frame];

      if ([[NSUserDefaults standardUserDefaults] boolForKey:kUseCustomFrame]) {
        CGFloat top = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameTop];
        CGFloat left = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameLeft];
        CGFloat width = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameWidth];
        CGFloat height = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameHeight];
        if (width < 1.0) width = 1.0;
        if (height < 1.0) height = 1.0;

        rect.origin.x += left;
        rect.origin.y += rect.size.height - top - height;
        rect.size.width = width;
        rect.size.height = height;

        [w setFrame:rect display:NO];

      } else {
        CGFloat width = rect.size.width;
        CGFloat height = [self.preferencesManager indicatorHeight];

        // To avoid top 1px gap, we need to add an adjust value to frame.size.height.
        // (Do not add an adjust value to frame.origin.y.)
        //
        // origin.y + size.height +-------------------------------------------+
        //                        |                                           |
        //               origin.y +-------------------------------------------+
        //                        origin.x                                    origin.x + size.width
        //

        CGFloat adjustHeight = view.adjustHeight;

        rect.origin.x += 0;
        rect.origin.y += rect.size.height - height;
        rect.size.width = width;
        rect.size.height = height + adjustHeight;

        [w setFrame:rect display:NO];
      }

      NSRect windowFrame = [w frame];
      [view setFrame:NSMakeRect(0, 0, windowFrame.size.width, windowFrame.size.height)];

      [w orderFront:nil];
    }
  }
}

- (void)setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2 {
  for (NSWindow* window in windows_) {
    [[window contentView] setColor:c0 c1:c1 c2:c2];
  }
}

- (void)observer_NSApplicationDidChangeScreenParametersNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"observer_NSApplicationDidChangeScreenParametersNotification");
    [self adjustFrame];
  });
}

- (void)observer_kIndicatorConfigurationChangedNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];
    [self observer_kCurrentInputSourceIDChangedNotification:nil];
  });
}

// ------------------------------------------------------------
- (void)observer_NSWindowWillCloseNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSWindow* window = [notification object];
    if (self.preferencesWindowController &&
        self.preferencesWindowController.window == window) {
      // PreferencesWindow is closed.
      self.preferencesWindowController = nil;
      if ([self.preferencesManager isRelaunchAfterClosingPreferencesWindow]) {
        [Relauncher relaunch];
      }
    }
  });
}

// ------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
  NSInteger relaunchedCount = [Relauncher getRelaunchedCount];

  // ------------------------------------------------------------
  windows_ = [NSMutableArray new];

  [Relauncher resetRelaunchedCount];

  [[NSApplication sharedApplication] disableRelaunchOnLogin];

  [self adjustFrame];

  // ------------------------------------------------------------
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                         selector:@selector(observer_NSWorkspaceDidActivateApplicationNotification:)
                                                             name:NSWorkspaceDidActivateApplicationNotification
                                                           object:nil];

  // ------------------------------------------------------------
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_kCurrentInputSourceIDChangedNotification:)
                                               name:kCurrentInputSourceIDChangedNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_kIndicatorConfigurationChangedNotification:)
                                               name:kIndicatorConfigurationChangedNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_NSApplicationDidChangeScreenParametersNotification:)
                                               name:NSApplicationDidChangeScreenParametersNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_NSWindowWillCloseNotification:)
                                               name:NSWindowWillCloseNotification
                                             object:nil];

  // ------------------------------------------------------------
  if (relaunchedCount == 0) {
    [self.updater checkForUpdatesInBackground];
  } else {
    NSLog(@"Skip checkForUpdatesInBackground in the relaunched process.");
  }

  // ------------------------------------------------------------
  if (![StartAtLoginUtilities isStartAtLogin] &&
      [[NSUserDefaults standardUserDefaults] boolForKey:kResumeAtLogin]) {
    [self openPreferences];
  }
  [ServerController updateStartAtLogin:YES];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication*)theApplication hasVisibleWindows:(BOOL)flag {
  [self openPreferences];
  return YES;
}

- (void)dealloc {
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)openPreferences {
  if (self.preferencesWindowController == nil) {
    self.preferencesWindowController = [[PreferencesWindowController alloc] initWithServerObjects:@"PreferencesWindow" serverObjects:self.serverObjects];
  }
  [self.preferencesWindowController show];
}

// ======================================================================
- (IBAction)quit:(id)sender {
  NSAlert* alert = [NSAlert alertWithMessageText:@"Quit ShowyEdge?"
                                   defaultButton:@"Quit"
                                 alternateButton:@"Cancel"
                                     otherButton:nil
                       informativeTextWithFormat:@"Are you sure you want to quit ShowyEdge?"];
  if ([alert runModal] != NSAlertDefaultReturn) return;

  [NSApp terminate:nil];
}

@end
