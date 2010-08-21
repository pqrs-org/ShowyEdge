/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import <Cocoa/Cocoa.h>

@interface LanguageColorTableViewController : NSObject {
  NSArray* colors_;
  NSMutableArray* data_;

  IBOutlet NSTableView* tableview_;

  IBOutlet NSMenu* menu_color0_;
  IBOutlet NSMenu* menu_color1_;
  IBOutlet NSMenu* menu_color2_;
}

- (void) setupMenu;
- (void) load;
- (void) save;
- (void) add:(NSString*)newInputSourceID;
- (void) remove;
- (NSDictionary*) getDictionaryFromInputSourceID:(NSString*)inputsourceid;
- (NSColor*) getColorFromName:(NSString*)colorName;

@end
