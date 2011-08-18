//
//  DrasticInputSourceStatusAppDelegate.m
//  DrasticInputSourceStatus
//
//  Created by Takayama Fumihiko on 10/08/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "DrasticInputSourceStatusAppDelegate.h"
#import "MenuBarOverlayView.h"

@implementation DrasticInputSourceStatusAppDelegate

@synthesize window;

- (void) observer_kTISNotifySelectedKeyboardInputSourceChanged:(NSNotification*)notification
{
  // ------------------------------------------------------------
  TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
  if (! ref) goto finish;

  MenuBarOverlayView* view = [window contentView];
  if (! view) goto finish;

  NSString* inputsourceid = TISGetInputSourceProperty(ref, kTISPropertyInputSourceID);
  if (! inputsourceid) {
    inputsourceid = @"org.pqrs.inputsourceid.unknown";
  }
  //NSLog(@"%@", inputsourceid);

  [currentInputSourceID_ setStringValue:inputsourceid];

  // ------------------------------------------------------------
  // check customized language color
  NSDictionary* dict = [languageColorTableViewController_ getDictionaryFromInputSourceID:inputsourceid];
  if (dict) {
    NSColor* color0 = [languageColorTableViewController_ getColorFromName:[dict objectForKey:@"color0"]];
    NSColor* color1 = [languageColorTableViewController_ getColorFromName:[dict objectForKey:@"color1"]];
    NSColor* color2 = [languageColorTableViewController_ getColorFromName:[dict objectForKey:@"color2"]];

    if (color0 && color1 && color2) {
      [view setColor:color0 c1:color1 c2:color2];
      goto finish;
    }
  }

  // ------------------------------------------------------------
  // default language color
  NSString* inputmodeid = TISGetInputSourceProperty(ref, kTISPropertyInputModeID);

  if (inputmodeid) {
    /*  */ if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.Katakana"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor greenColor] c2:[NSColor whiteColor]];

    } else if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.HalfWidthKana"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor purpleColor] c2:[NSColor whiteColor]];

    } else if ([inputmodeid isEqual:@"com.apple.inputmethod.Japanese.FullWidthRoman"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor yellowColor] c2:[NSColor whiteColor]];

    } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Japanese"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor redColor] c2:[NSColor whiteColor]];

    } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.TCIM"]) { // TradChinese
      [view setColor:[NSColor redColor] c1:[NSColor redColor] c2:[NSColor redColor]];

    } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.SCIM"]) { // SimpChinese
      [view setColor:[NSColor redColor] c1:[NSColor redColor] c2:[NSColor redColor]];

    } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Korean"]) {
      [view setColor:[NSColor redColor] c1:[NSColor blueColor] c2:[NSColor clearColor]];

    } else if ([inputmodeid hasPrefix:@"com.apple.inputmethod.Roman"]) {
      [view setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];

    } else {
      [view setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];
    }

  } else {
    /*  */ if ([inputsourceid hasPrefix:@"com.apple.keylayout.British"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor redColor] c2:[NSColor blueColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Canadian"]) {
      [view setColor:[NSColor redColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.French"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.German"]) {
      [view setColor:[NSColor grayColor] c1:[NSColor redColor] c2:[NSColor yellowColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Italian"]) {
      [view setColor:[NSColor greenColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Kazakh"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor yellowColor] c2:[NSColor blueColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Portuguese"]) {
      [view setColor:[NSColor greenColor] c1:[NSColor redColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Russian"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor blueColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Swedish"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor yellowColor] c2:[NSColor blueColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Spanish"]) {
      [view setColor:[NSColor redColor] c1:[NSColor yellowColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Swiss"]) {
      [view setColor:[NSColor redColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Dvorak"]) {
      [view setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keyboardlayout.fr-dvorak-bepo.keylayout.FrenchDvorak"]) {
      [view setColor:[NSColor grayColor] c1:[NSColor grayColor] c2:[NSColor grayColor]];

    } else {
      [view setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];
    }
  }

finish:
  if (ref) {
    CFRelease(ref);
  }
}

- (void) adjustFrame
{
  NSRect rect = [[NSScreen mainScreen] frame];
  CGFloat width = rect.size.width / 2;
  // Note:
  // MenuBarOverlayView height == 22 and NSWindow height == 21.
  // This difference is correct.
  CGFloat height = 21;
  [window setFrame:NSMakeRect(0, rect.size.height - height, width, height) display:NO];
  [[window contentView] adjustFrame];
}

- (void) observer_NSApplicationDidChangeScreenParametersNotification:(NSNotification*)notification
{
  NSLog(@"observer_NSApplicationDidChangeScreenParametersNotification");
  [window orderOut:nil];
  [self adjustFrame];
  [window orderFront:nil];
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {
  NSWindowCollectionBehavior behavior = NSWindowCollectionBehaviorCanJoinAllSpaces |
                                        NSWindowCollectionBehaviorStationary |
                                        NSWindowCollectionBehaviorIgnoresCycle;

  [window setAlphaValue:(CGFloat)(0.5)];
  [window setBackgroundColor:[NSColor clearColor]];
  [window setOpaque:NO];
  [window setHasShadow:NO];
  [window setStyleMask:NSBorderlessWindowMask];
  [window setLevel:NSStatusWindowLevel];
  [window setIgnoresMouseEvents:YES];
  [window setCollectionBehavior:behavior];

  [self adjustFrame];
  [[window contentView] setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];
  [window orderFront:nil];

  // ------------------------------------------------------------
  [languageColorTableViewController_ setupMenu];
  [languageColorTableViewController_ load];

  // ------------------------------------------------------------
  // In Mac OS X 10.7, NSDistributedNotificationCenter is suspended after calling [NSAlert runModal].
  // So, we need to set suspendedDeliveryBehavior to NSNotificationSuspensionBehaviorDeliverImmediately.
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                          name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                        object:nil
                                            suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                               name:@"updateMenubarColor"
                                             object:nil];

  [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];

  // ------------------------------------------------------------
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(observer_NSApplicationDidChangeScreenParametersNotification:)
                                               name:NSApplicationDidChangeScreenParametersNotification
                                             object:nil];
}

- (void) dealloc
{
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [super dealloc];
}

// ======================================================================
- (IBAction) add:(id)sender
{
  [languageColorTableViewController_ add:[currentInputSourceID_ stringValue]];
}

- (IBAction) remove:(id)sender
{
  [languageColorTableViewController_ remove];
}

- (IBAction) showPreferences:(id)sender
{
  [preferencesWindow_ makeKeyAndOrderFront:nil];
}

@end
