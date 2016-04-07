// -*- Mode: objc -*-

@import Cocoa;

@class PreferencesModel;
@class ServerClient;

@interface ColorsCellView : NSTableCellView

@property(weak) IBOutlet NSColorWell* color0;
@property(weak) IBOutlet NSColorWell* color1;
@property(weak) IBOutlet NSColorWell* color2;
@property(copy) NSString* inputSourceID;
@property(weak) NSTableView* tableView;
@property(weak) PreferencesModel* preferencesModel;
@property(weak) ServerClient* client;

@end
