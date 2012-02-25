// -*- Mode: objc -*-

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject {
  IBOutlet NSButton* startAtLogin_;
  IBOutlet NSButton* hideIconInDock_;
}

- (void) load;
+ (BOOL) isHideIconInDock;

- (IBAction) setStartAtLogin:(id)sender;
- (IBAction) setHideIconInDock:(id)sender;

@end
