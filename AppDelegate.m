#import <Carbon/Carbon.h>
#import "AppDelegate.h"
#import "LanguageColorTableViewController.h"
#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
#import "PreferencesController.h"
#import "PreferencesKeys.h"
#import "Sparkle/SUUpdater.h"
#import "StartAtLoginUtilities.h"

@interface AppDelegate () {
  NSMutableArray* windows_;
}
@end

@implementation AppDelegate

- (void)observer_NSWorkspaceDidActivateApplicationNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];
  });
}

- (void)observer_kTISNotifySelectedKeyboardInputSourceChanged:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];

    // ------------------------------------------------------------
    TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
    if (!ref) goto finish;

    {
      NSString* inputsourceid = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputSourceID));
      if (!inputsourceid) {
        inputsourceid = @"org.pqrs.inputsourceid.unknown";
      }
      // NSLog(@"%@", inputsourceid);

      [self.currentInputSourceID setStringValue:inputsourceid];

      // ------------------------------------------------------------
      // check customized language color
      NSDictionary* dict = [self.languageColorTableViewController getDictionaryFromInputSourceID:inputsourceid];
      if (dict) {
        NSColor* color0 = [self.languageColorTableViewController getColorFromName:dict[@"color0"]];
        NSColor* color1 = [self.languageColorTableViewController getColorFromName:dict[@"color1"]];
        NSColor* color2 = [self.languageColorTableViewController getColorFromName:dict[@"color2"]];

        if (color0 && color1 && color2) {
          [self setColor:color0 c1:color1 c2:color2];
          goto finish;
        }
      }

      // ------------------------------------------------------------
      // default language color
      NSString* inputmodeid = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputModeID));

      if (inputmodeid) {
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
    }

  finish:
    if (ref) {
      CFRelease(ref);
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
        CGFloat height = [PreferencesController indicatorHeight];

        // To avoid top 1px gap, we need to add an adjust value to frame.size.height.
        // (Do not add an adjust value to frame.origin.y.)
        //
        // origin.y + size.height +-------------------------------------------+
        //                        |                                           |
        //               origin.y +-------------------------------------------+
        //                        origin.x                                    origin.x + size.width
        //

        CGFloat adjustHeight = 2.0;

        rect.origin.x += 0;
        rect.origin.y += rect.size.height - height;
        rect.size.width = width;
        rect.size.height = height + adjustHeight;

        [w setFrame:rect display:NO];
      }

      NSRect windowFrame = [w frame];
      [[w contentView] setFrame:NSMakeRect(0, 0, windowFrame.size.width, windowFrame.size.height)];

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

- (void)observer_kIndicatorHeightChangedNotification:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self adjustFrame];
    [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];
  });
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
  windows_ = [NSMutableArray new];

  [self.preferences load];

  [[NSApplication sharedApplication] disableRelaunchOnLogin];

  if ([[NSUserDefaults standardUserDefaults] boolForKey:kShowIconInDock]) {
    ProcessSerialNumber psn = {0, kCurrentProcess};
    TransformProcessType(&psn, kProcessTransformToForegroundApplication);
  }

  [self adjustFrame];

  // ------------------------------------------------------------
  [self.languageColorTableViewController setupMenu];
  [self.languageColorTableViewController load];

  // ------------------------------------------------------------
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                         selector:@selector(observer_NSWorkspaceDidActivateApplicationNotification:)
                                                             name:NSWorkspaceDidActivateApplicationNotification
                                                           object:nil];

  // In Mac OS X 10.7, NSDistributedNotificationCenter is suspended after calling [NSAlert runModal].
  // So, we need to set suspendedDeliveryBehavior to NSNotificationSuspensionBehaviorDeliverImmediately.
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                          name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                        object:nil
                                            suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                               name:kIndicatorColorChangedNotification
                                             object:nil];

  [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];

  // ------------------------------------------------------------
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_kIndicatorHeightChangedNotification:)
                                               name:kIndicatorHeightChangedNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_NSApplicationDidChangeScreenParametersNotification:)
                                               name:NSApplicationDidChangeScreenParametersNotification
                                             object:nil];

  // ------------------------------------------------------------
  if (![StartAtLoginUtilities isStartAtLogin]) {
    [self.preferencesWindow makeKeyAndOrderFront:nil];
  }

  // ------------------------------------------------------------
  [self.suupdater checkForUpdatesInBackground];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication*)theApplication hasVisibleWindows:(BOOL)flag {
  [self.preferencesWindow makeKeyAndOrderFront:nil];
  return YES;
}

- (void)dealloc {
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)add:(id)sender {
  [self.languageColorTableViewController add:[self.currentInputSourceID stringValue]];
}

- (IBAction)remove:(id)sender {
  [self.languageColorTableViewController remove];
}

- (IBAction)checkForUpdatesWithBetaVersion:(id)sender {
  NSURL* originalURL = [self.suupdater feedURL];
  NSURL* url = [NSURL URLWithString:@"https://pqrs.org/osx/ShowyEdge/files/appcast-devel.xml"];
  [self.suupdater setFeedURL:url];
  [self.suupdater checkForUpdates:nil];
  [self.suupdater setFeedURL:originalURL];
}

@end
