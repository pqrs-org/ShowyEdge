// -*- mode: objective-c -*-

@import Cocoa;

@class PreferencesClient;

@interface ColorsCellView : NSTableCellView

@property(weak) IBOutlet NSColorWell* color0;
@property(weak) IBOutlet NSColorWell* color1;
@property(weak) IBOutlet NSColorWell* color2;
@property(copy) NSString* inputSourceID;
@property(weak) NSTableView* tableView;
@property(weak) PreferencesClient* preferencesClient;

@end
