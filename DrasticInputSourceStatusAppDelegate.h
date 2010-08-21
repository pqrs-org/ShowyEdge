/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */
//
//  DrasticInputSourceStatusAppDelegate.h
//  DrasticInputSourceStatus
//
//  Created by Takayama Fumihiko on 10/08/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LanguageColorTableViewController.h"

@interface DrasticInputSourceStatusAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow* window;

  IBOutlet NSWindow* preferencesWindow_;
  IBOutlet LanguageColorTableViewController* languageColorTableViewController_;
  IBOutlet NSTextField* currentInputSourceID_;
}

@property (assign) IBOutlet NSWindow* window;
- (IBAction) add:(id)sender;
- (IBAction) remove:(id)sender;
- (IBAction) showPreferences:(id)sender;

@end
