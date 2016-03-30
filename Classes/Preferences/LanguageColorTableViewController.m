/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "LanguageColorTableViewController.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "PreferencesWindowController.h"
#import "ServerObjects.h"

@interface LanguageColorTableViewController ()

@property(weak) IBOutlet PreferencesWindowController* preferencesWindowController;
@property(weak) IBOutlet NSTableView* tableview;
@property(weak) IBOutlet NSMenu* menu_color0;
@property(weak) IBOutlet NSMenu* menu_color1;
@property(weak) IBOutlet NSMenu* menu_color2;

@end

@implementation LanguageColorTableViewController

- (void)setupMenu {
  if (self.menu_color0.numberOfItems > 0) {
    return;
  }

  NSArray* menus = @[ self.menu_color0, self.menu_color1, self.menu_color2 ];

  for (NSArray* nameAndColor in self.preferencesWindowController.serverObjects.preferencesManager.colors) {
    NSString* name = nameAndColor[0];
    NSColor* color = nameAndColor[1];

    for (NSMenu* menu in menus) {
      NSMenuItem* newItem = [[NSMenuItem alloc] initWithTitle:name action:NULL keyEquivalent:@""];

      // ----------------------------------------
      // Add image icon
      enum {
        IMAGE_WIDTH = 40,
        IMAGE_HEIGHT = 16,
        BORDER_WIDTH = 2,
      };
      NSImage* newImage = [[NSImage alloc] initWithSize:NSMakeSize(IMAGE_WIDTH, IMAGE_HEIGHT)];
      if (![name isEqual:@"clear"]) {
        [newImage lockFocus];
        {
          [[NSColor whiteColor] set];
          NSRectFill(NSMakeRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT));

          [color set];
          NSRectFill(NSMakeRect(BORDER_WIDTH, BORDER_WIDTH, IMAGE_WIDTH - BORDER_WIDTH * 2, IMAGE_HEIGHT - BORDER_WIDTH * 2));
        }
        [newImage unlockFocus];
      }
      [newItem setImage:newImage];

      // ----------------------------------------
      [menu addItem:newItem];
    }
  }

  [self.tableview reloadData];
}

// ----------------------------------------------------------------------
- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
  return [[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor] count];
}

- (id)tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)rowIndex {
  NSString* identifier = [aTableColumn identifier];
  NSDictionary* dict = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor][rowIndex];
  NSString* value = dict[identifier];

  if ([identifier isEqual:@"inputsourceid"]) {
    return value;
  }

  if ([identifier isEqual:@"color0"] ||
      [identifier isEqual:@"color1"] ||
      [identifier isEqual:@"color2"]) {
    int i = 0;
    for (NSArray* nameAndColor in self.preferencesWindowController.serverObjects.preferencesManager.colors) {
      NSString* name = nameAndColor[0];
      if ([name isEqual:value]) {
        return [NSString stringWithFormat:@"%d", i];
      }
      ++i;
    }
    return 0;
  }

  return nil;
}

- (void)tableView:(NSTableView*)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)rowIndex {
  NSString* identifier = [aTableColumn identifier];

  if ([identifier isEqual:@"inputsourceid"]) {
    return;
  }

  if ([identifier isEqual:@"color0"] ||
      [identifier isEqual:@"color1"] ||
      [identifier isEqual:@"color2"]) {
    NSArray* nameAndColor = (self.preferencesWindowController.serverObjects.preferencesManager.colors)[[anObject integerValue]];
    NSString* name = nameAndColor[0];

    NSMutableDictionary* dict = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor][rowIndex];

    dict[identifier] = name;

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorConfigurationChangedNotification object:nil userInfo:nil]];

    return;
  }
}

@end
