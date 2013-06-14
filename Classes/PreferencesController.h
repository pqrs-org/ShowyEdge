// -*- Mode: objc -*-

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject {
  IBOutlet NSButton* startAtLogin_;
}

- (void) load;
+ (CGFloat) indicatorHeight;

- (IBAction) setStartAtLogin:(id)sender;
- (IBAction) indicatorHeightChanged:(id)sender;

@end
