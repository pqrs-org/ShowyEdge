/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "LanguageColorTableViewController.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"

@interface LanguageColorTableViewController ()

@property (nonatomic, strong) NSArray* colors;
@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation LanguageColorTableViewController

- (id) init
{
  self = [super init];

  if (self) {
    self.data = [NSMutableArray new];

    NSMutableArray* colorsWithAlpha = [NSMutableArray new];
    NSArray* sources = @[
      // We use grayColor as "black" because blackColor is too dark.
      @[@"black",   [NSColor grayColor]],
      @[@"blue",    [NSColor blueColor]],
      @[@"brown",   [NSColor brownColor]],
      @[@"clear",   [NSColor clearColor]],
      @[@"cyan",    [NSColor cyanColor]],
      @[@"green",   [NSColor greenColor]],
      @[@"magenta", [NSColor magentaColor]],
      @[@"orange",  [NSColor orangeColor]],
      @[@"purple",  [NSColor purpleColor]],
      @[@"red",     [NSColor redColor]],
      @[@"white",   [NSColor whiteColor]],
      @[@"yellow",  [NSColor yellowColor]],

      // ------------------------------------------------------------
      // more colors
      // black 0.0f, 0.0f, 0.0f
      @[@"black1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f]],
      @[@"black0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.8f]],
      @[@"black0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.6f]],
      @[@"black0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.4f]],
      @[@"black0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.2f]],

      // gray 0.5f, 0.5f, 0.5f
      @[@"gray1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:1.0f]],
      @[@"gray0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.8f]],
      @[@"gray0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.6f]],
      @[@"gray0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.4f]],
      @[@"gray0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.2f]],

      // silver 0.75f, 0.75f, 0.75f
      @[@"silver1.0",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:1.0f]],
      @[@"silver0.8",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.8f]],
      @[@"silver0.6",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.6f]],
      @[@"silver0.4",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.4f]],
      @[@"silver0.2",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.2f]],

      // white 1.0f, 1.0f, 1.0f
      @[@"white1.0",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f]],
      @[@"white0.8",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.8f]],
      @[@"white0.6",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.6f]],
      @[@"white0.4",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.4f]],
      @[@"white0.2",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.2f]],

      // maroon 0.5f, 0.0f, 0.0f
      @[@"maroon1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:1.0f]],
      @[@"maroon0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.8f]],
      @[@"maroon0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.6f]],
      @[@"maroon0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.4f]],
      @[@"maroon0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.2f]],

      // red 1.0f, 0.0f, 0.0f
      @[@"red1.0",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:1.0f]],
      @[@"red0.8",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.8f]],
      @[@"red0.6",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.6f]],
      @[@"red0.4",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.4f]],
      @[@"red0.2",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.2f]],

      // olive 0.5f, 0.5f, 0.0f
      @[@"olive1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:1.0f]],
      @[@"olive0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.8f]],
      @[@"olive0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.6f]],
      @[@"olive0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.4f]],
      @[@"olive0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.2f]],

      // yellow 1.0f, 1.0f, 0.0f
      @[@"yellow1.0",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:1.0f]],
      @[@"yellow0.8",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.8f]],
      @[@"yellow0.6",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.6f]],
      @[@"yellow0.4",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.4f]],
      @[@"yellow0.2",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.2f]],

      // green 0.0f, 0.5f, 0.0f
      @[@"green1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:1.0f]],
      @[@"green0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.8f]],
      @[@"green0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.6f]],
      @[@"green0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.4f]],
      @[@"green0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.2f]],

      // lime 0.0f, 1.0f, 0.0f
      @[@"lime1.0",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:1.0f]],
      @[@"lime0.8",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.8f]],
      @[@"lime0.6",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.6f]],
      @[@"lime0.4",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.4f]],
      @[@"lime0.2",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.2f]],

      // teal 0.0f, 0.5f, 0.5f
      @[@"teal1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:1.0f]],
      @[@"teal0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.8f]],
      @[@"teal0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.6f]],
      @[@"teal0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.4f]],
      @[@"teal0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.2f]],

      // aqua 0.0f, 1.0f, 1.0f
      @[@"aqua1.0",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:1.0f]],
      @[@"aqua0.8",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.8f]],
      @[@"aqua0.6",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.6f]],
      @[@"aqua0.4",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.4f]],
      @[@"aqua0.2",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.2f]],

      // navy 0.0f, 0.0f, 0.5f
      @[@"navy1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:1.0f]],
      @[@"navy0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.8f]],
      @[@"navy0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.6f]],
      @[@"navy0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.4f]],
      @[@"navy0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.2f]],

      // blue 0.0f, 0.0f, 1.0f
      @[@"blue1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:1.0f]],
      @[@"blue0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.8f]],
      @[@"blue0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.6f]],
      @[@"blue0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.4f]],
      @[@"blue0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.2f]],

      // purple 0.5f, 0.0f, 0.5f
      @[@"purple1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:1.0f]],
      @[@"purple0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.8f]],
      @[@"purple0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.6f]],
      @[@"purple0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.4f]],
      @[@"purple0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.2f]],

      // fuchsia 1.0f, 0.0f, 1.0f
      @[@"fuchsia1.0",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:1.0f]],
      @[@"fuchsia0.8",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.8f]],
      @[@"fuchsia0.6",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.6f]],
      @[@"fuchsia0.4",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.4f]],
      @[@"fuchsia0.2",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.2f]],
                       ];
    for (NSArray* a in sources) {
      CGFloat alpha = [a[1] alphaComponent];
      [colorsWithAlpha addObject:@[a[0], [a[1] colorWithAlphaComponent:(alpha * 0.5)]]];
    }
    self.colors = colorsWithAlpha;
  }

  return self;
}

- (void) setupMenu
{
  NSArray* menus = @[self.menu_color0, self.menu_color1, self.menu_color2];

  for (NSArray* nameAndColor in self.colors) {
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
      if (! [name isEqual:@"clear"]) {
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

static NSInteger
compareDictionary(NSDictionary* dict1, NSDictionary* dict2, void* context)
{
  return [dict1[@"inputsourceid"] compare:dict2[@"inputsourceid"]];
}

- (void) sort
{
  [self.data sortUsingFunction:compareDictionary context:NULL];
}

- (void) load
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSArray* saveddata = [defaults arrayForKey:kCustomizedLanguageColor];

  for (NSDictionary* dict in saveddata) {
    [self.data addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
  }

  [self sort];
  [self.tableview reloadData];
}

- (void) save
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:self.data forKey:kCustomizedLanguageColor];
  [defaults synchronize];
}

- (void) add:(NSString*)newInputSourceID
{
  // unique check
  for (NSDictionary* dict in self.data) {
    NSString* name = dict[@"inputsourceid"];
    if ([name isEqual:newInputSourceID]) goto added;
  }

  {
    NSArray* keys = @[@"inputsourceid", @"color0", @"color1", @"color2"];
    NSArray* objects = @[newInputSourceID, @"white", @"white", @"white"];
    [self.data addObject:[NSMutableDictionary dictionaryWithObjects:objects forKeys:keys]];
  }

added:
  [self sort];
  // call reloadData once before selectRowIndexes.
  [self.tableview reloadData];

  NSUInteger rowIndex = 0;
  for (NSDictionary* dict in self.data) {
    NSString* name = dict[@"inputsourceid"];
    if ([name isEqual:newInputSourceID]) {
      [self.tableview selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
      [self.tableview scrollRowToVisible:rowIndex];
      break;
    }
    ++rowIndex;
  }

  [self.tableview reloadData];
  [self save];
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];
}

- (void) remove
{
  NSInteger rowIndex = [self.tableview selectedRow];
  if (rowIndex == -1) return;

  [self.data removeObjectAtIndex:rowIndex];
  [self.tableview reloadData];
  [self save];
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];
}

- (NSDictionary*) getDictionaryFromInputSourceID:(NSString*)inputsourceid
{
  for (NSDictionary* dict in self.data) {
    NSString* name = dict[@"inputsourceid"];
    if ([name isEqual:inputsourceid]) {
      return dict;
    }
  }
  return nil;
}

- (NSColor*) getColorFromName:(NSString*)colorName
{
  for (NSArray* nameAndColor in self.colors) {
    NSString* name = nameAndColor[0];
    NSColor* color = nameAndColor[1];
    if ([name isEqual:colorName]) {
      return color;
    }
  }
  return nil;
}

// ----------------------------------------------------------------------
- (NSInteger) numberOfRowsInTableView:(NSTableView*)aTableView
{
  return [self.data count];
}

- (id) tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)rowIndex
{
  NSString* identifier = [aTableColumn identifier];
  NSDictionary* dict = [self.data objectAtIndex:rowIndex];
  NSString* value = dict[identifier];

  if ([identifier isEqual:@"inputsourceid"]) {
    return value;
  }

  if ([identifier isEqual:@"color0"] ||
      [identifier isEqual:@"color1"] ||
      [identifier isEqual:@"color2"]) {
    int i = 0;
    for (NSArray* nameAndColor in self.colors) {
      NSString* name = [nameAndColor objectAtIndex:0];
      if ([name isEqual:value]) {
        return [NSString stringWithFormat:@"%d", i];
      }
      ++i;
    }
    return 0;
  }

  return nil;
}

- (void) tableView:(NSTableView*)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)rowIndex
{
  NSString* identifier = [aTableColumn identifier];

  if ([identifier isEqual:@"inputsourceid"]) {
    return;
  }

  if ([identifier isEqual:@"color0"] ||
      [identifier isEqual:@"color1"] ||
      [identifier isEqual:@"color2"]) {
    NSArray* nameAndColor = [self.colors objectAtIndex:[anObject integerValue]];
    NSString* name = [nameAndColor objectAtIndex:0];

    NSMutableDictionary* dict = [self.data objectAtIndex:rowIndex];
    [dict setObject:name forKey:identifier];

    [self save];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];

    return;
  }
}

@end
