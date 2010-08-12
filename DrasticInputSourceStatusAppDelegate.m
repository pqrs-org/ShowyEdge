//
//  DrasticInputSourceStatusAppDelegate.m
//  DrasticInputSourceStatus
//
//  Created by Takayama Fumihiko on 10/08/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "DrasticInputSourceStatusAppDelegate.h"

@implementation DrasticInputSourceStatusAppDelegate

@synthesize window;

- (void) observer_kTISNotifySelectedKeyboardInputSourceChanged:(NSNotification*)notification
{
  TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
  if (! ref) return;

  NSString* inputmodeid = TISGetInputSourceProperty(ref, kTISPropertyInputModeID);

  if (inputmodeid && [inputmodeid hasPrefix:@"com.apple.inputmethod.Japanese"]) {
    [window orderFront:nil];
  } else {
    [window orderOut:nil];
  }
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {
  NSWindowCollectionBehavior behavior = NSWindowCollectionBehaviorCanJoinAllSpaces |
                                        NSWindowCollectionBehaviorStationary |
                                        NSWindowCollectionBehaviorIgnoresCycle;

  [window setAlphaValue:0.5];
  [window setBackgroundColor:[NSColor redColor]];
  [window setOpaque:NO];
  [window setStyleMask:NSBorderlessWindowMask];
  [window setLevel:NSStatusWindowLevel];
  [window setIgnoresMouseEvents:YES];
  [window setCollectionBehavior:behavior];

  NSRect rect = [[NSScreen mainScreen] frame];
  NSRect framerect = NSMakeRect(0, rect.size.height - 22, rect.size.width / 2, rect.size.height);
  [window setFrame:framerect display:NO];

  // ------------------------------------------------------------
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                          name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                        object:nil];
  [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];
}

@end
