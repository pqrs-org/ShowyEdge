// -*- Mode: objc -*-

@import Cocoa;

@interface PreferencesController : NSObject

@property(assign) IBOutlet NSButton* startAtLogin;
@property(assign) IBOutlet NSTextField* version;

- (void)load;
+ (CGFloat)indicatorHeight;

- (IBAction)toggleStartAtLogin:(id)sender;
- (IBAction)indicatorHeightChanged:(id)sender;
- (IBAction)openURL:(id)sender;

@end
