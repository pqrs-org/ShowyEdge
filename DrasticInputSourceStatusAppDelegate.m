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
  TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
  if (! ref) return;

  MenuBarOverlayView* view = [window contentView];
  if (! view) return;

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
      [view setColor:[NSColor blackColor] c1:[NSColor blackColor] c2:[NSColor blackColor]];
    }

  } else {
    NSString* inputsourceid = TISGetInputSourceProperty(ref, kTISPropertyInputSourceID);
    //NSLog(@"%@", inputsourceid);

    /*  */ if ([inputsourceid hasPrefix:@"com.apple.keylayout.British"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor redColor] c2:[NSColor blueColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Canadian"]) {
      [view setColor:[NSColor redColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.French"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.German"]) {
      [view setColor:[NSColor blackColor] c1:[NSColor redColor] c2:[NSColor yellowColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Italian"]) {
      [view setColor:[NSColor greenColor] c1:[NSColor whiteColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Russian"]) {
      [view setColor:[NSColor whiteColor] c1:[NSColor blueColor] c2:[NSColor redColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Swedish"]) {
      [view setColor:[NSColor blueColor] c1:[NSColor yellowColor] c2:[NSColor blueColor]];

    } else if ([inputsourceid hasPrefix:@"com.apple.keylayout.Dvorak"]) {
      [view setColor:[NSColor grayColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];

    } else {
      [view setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];
    }
  }
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {
  NSWindowCollectionBehavior behavior = NSWindowCollectionBehaviorCanJoinAllSpaces |
                                        NSWindowCollectionBehaviorStationary |
                                        NSWindowCollectionBehaviorIgnoresCycle;

  [window setAlphaValue:(CGFloat)(0.5)];
  [window setBackgroundColor:[NSColor clearColor]];
  [window setOpaque:NO];
  [window setStyleMask:NSBorderlessWindowMask];
  [window setLevel:NSStatusWindowLevel];
  [window setIgnoresMouseEvents:YES];
  [window setCollectionBehavior:behavior];

  NSRect rect = [[NSScreen mainScreen] frame];
  CGFloat width = rect.size.width / 2;
  // Note:
  // MenuBarOverlayView height == 22 and NSWindow height == 21.
  // This difference is correct.
  CGFloat height = 21;
  [window setFrame:NSMakeRect(0, rect.size.height - height, width, rect.size.height) display:NO];
  [[window contentView] initializeFrame];
  [[window contentView] setColor:[NSColor clearColor] c1:[NSColor clearColor] c2:[NSColor clearColor]];
  [window orderFront:nil];

  // ------------------------------------------------------------
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                          name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                        object:nil];
  [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];
}

@end
