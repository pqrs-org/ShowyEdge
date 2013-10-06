/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import <Cocoa/Cocoa.h>

@interface LanguageColorTableViewController : NSObject

@property (assign) IBOutlet NSTableView* tableview;
@property (assign) IBOutlet NSMenu* menu_color0;
@property (assign) IBOutlet NSMenu* menu_color1;
@property (assign) IBOutlet NSMenu* menu_color2;

- (void) setupMenu;
- (void) load;
- (void) add:(NSString*)newInputSourceID;
- (void) remove;
- (NSDictionary*) getDictionaryFromInputSourceID:(NSString*)inputsourceid;
- (NSColor*) getColorFromName:(NSString*)colorName;

@end
