// -*- Mode: objc -*-
//
//  KeyRemap4MacBook_multitouchextensionAppDelegate.h
//  KeyRemap4MacBook_multitouchextension
//
//  Created by Takayama Fumihiko on 09/11/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"
#import "StartAtLoginController.h"

@implementation PreferencesController

- (void) load
{
  if ([StartAtLoginController isStartAtLogin]) {
    [startAtLogin_ setState:NSOnState];
  } else {
    [startAtLogin_ setState:NSOffState];
  }

  if ([PreferencesController isHideIconInDock]) {
    [hideIconInDock_ setState:NSOnState];
  } else {
    [hideIconInDock_ setState:NSOffState];
  }
}

- (IBAction) setStartAtLogin:(id)sender
{
  // startAtLogin
  if ([StartAtLoginController isStartAtLogin]) {
    [StartAtLoginController setStartAtLogin:NO];
  } else {
    [StartAtLoginController setStartAtLogin:YES];
  }
}

- (IBAction) setHideIconInDock:(id)sender
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString* key = @"hideIconInDock";

  if ([hideIconInDock_ state] == NSOnState) {
    [defaults setBool:YES forKey:key];
  } else {
    [defaults setBool:NO forKey:key];
  }
}

+ (BOOL) isHideIconInDock
{
  // Default value is NO.
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideIconInDock"];
}

@end
