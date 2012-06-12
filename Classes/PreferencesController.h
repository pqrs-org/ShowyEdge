// -*- Mode: objc -*-

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject {
  IBOutlet NSButton* startAtLogin_;
  IBOutlet NSButton* hideIconInDock_;
  IBOutlet NSPopUpButton* indicatorShape_;
}

- (void) load;
+ (BOOL) isHideIconInDock;
+ (NSString*) indicatorShape;
+ (CGFloat) indicatorWidth;
+ (CGFloat) indicatorHeight;

- (IBAction) setStartAtLogin:(id)sender;
- (IBAction) setHideIconInDock:(id)sender;
- (IBAction) setIndicatorShape:(id)sender;

@end
