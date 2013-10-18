// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

#import <Cocoa/Cocoa.h>

@class PreferencesController;
@class LanguageColorTableViewController;
@class SUUpdater;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet LanguageColorTableViewController* languageColorTableViewController;
@property (assign) IBOutlet NSTextField* currentInputSourceID;
@property (assign) IBOutlet NSWindow* preferencesWindow;
@property (assign) IBOutlet NSWindow* window;
@property (assign) IBOutlet PreferencesController* preferences;
@property (assign) IBOutlet SUUpdater* suupdater;

- (IBAction) add:(id)sender;
- (IBAction) remove:(id)sender;
- (IBAction) checkForUpdatesWithBetaVersion:(id)sender;

@end
