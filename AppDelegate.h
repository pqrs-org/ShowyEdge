// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

#import <Cocoa/Cocoa.h>

@class PreferencesController;
@class LanguageColorTableViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow* window;

  IBOutlet NSWindow* preferencesWindow_;
  IBOutlet PreferencesController* preferences_;
  IBOutlet LanguageColorTableViewController* languageColorTableViewController_;
  IBOutlet NSTextField* currentInputSourceID_;
}

@property (assign) IBOutlet NSWindow* window;
- (IBAction) add:(id)sender;
- (IBAction) remove:(id)sender;

@end
