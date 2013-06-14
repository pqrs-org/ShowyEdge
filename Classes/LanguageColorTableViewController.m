/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "LanguageColorTableViewController.h"
#import "NotificationKeys.h"

@implementation LanguageColorTableViewController

- (id) init
{
  self = [super init];
  if (self) {
    data_ = [[NSMutableArray alloc] init];

    colors_ = [NSArray arrayWithObjects:
               // We use grayColor as "black" because blackColor is too dark.
               [NSArray arrayWithObjects:@"black",   [NSColor grayColor],    nil],
               [NSArray arrayWithObjects:@"blue",    [NSColor blueColor],    nil],
               [NSArray arrayWithObjects:@"brown",   [NSColor brownColor],   nil],
               [NSArray arrayWithObjects:@"clear",   [NSColor clearColor],   nil],
               [NSArray arrayWithObjects:@"cyan",    [NSColor cyanColor],    nil],
               [NSArray arrayWithObjects:@"green",   [NSColor greenColor],   nil],
               [NSArray arrayWithObjects:@"magenta", [NSColor magentaColor], nil],
               [NSArray arrayWithObjects:@"orange",  [NSColor orangeColor],  nil],
               [NSArray arrayWithObjects:@"purple",  [NSColor purpleColor],  nil],
               [NSArray arrayWithObjects:@"red",     [NSColor redColor],     nil],
               [NSArray arrayWithObjects:@"white",   [NSColor whiteColor],   nil],
               [NSArray arrayWithObjects:@"yellow",  [NSColor yellowColor],  nil],

               // ------------------------------------------------------------
               // more colors
               // black 0.0f, 0.0f, 0.0f
               [NSArray arrayWithObjects:@"black1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"black0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"black0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"black0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"black0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.2f],     nil],

               // gray 0.5f, 0.5f, 0.5f
               [NSArray arrayWithObjects:@"gray1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"gray0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"gray0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"gray0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"gray0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.2f],     nil],

               // silver 0.75f, 0.75f, 0.75f
               [NSArray arrayWithObjects:@"silver1.0",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"silver0.8",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"silver0.6",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"silver0.4",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"silver0.2",     [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.2f],     nil],

               // white 1.0f, 1.0f, 1.0f
               [NSArray arrayWithObjects:@"white1.0",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"white0.8",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"white0.6",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"white0.4",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"white0.2",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.2f],     nil],

               // maroon 0.5f, 0.0f, 0.0f
               [NSArray arrayWithObjects:@"maroon1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"maroon0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"maroon0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"maroon0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"maroon0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.2f],     nil],

               // red 1.0f, 0.0f, 0.0f
               [NSArray arrayWithObjects:@"red1.0",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"red0.8",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"red0.6",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"red0.4",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"red0.2",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.2f],     nil],

               // olive 0.5f, 0.5f, 0.0f
               [NSArray arrayWithObjects:@"olive1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"olive0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"olive0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"olive0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"olive0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.2f],     nil],

               // yellow 1.0f, 1.0f, 0.0f
               [NSArray arrayWithObjects:@"yellow1.0",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"yellow0.8",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"yellow0.6",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"yellow0.4",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"yellow0.2",     [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.2f],     nil],

               // green 0.0f, 0.5f, 0.0f
               [NSArray arrayWithObjects:@"green1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"green0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"green0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"green0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"green0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.2f],     nil],

               // lime 0.0f, 1.0f, 0.0f
               [NSArray arrayWithObjects:@"lime1.0",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"lime0.8",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"lime0.6",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"lime0.4",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"lime0.2",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.2f],     nil],

               // teal 0.0f, 0.5f, 0.5f
               [NSArray arrayWithObjects:@"teal1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"teal0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"teal0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"teal0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"teal0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.2f],     nil],

               // aqua 0.0f, 1.0f, 1.0f
               [NSArray arrayWithObjects:@"aqua1.0",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"aqua0.8",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"aqua0.6",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"aqua0.4",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"aqua0.2",     [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.2f],     nil],

               // navy 0.0f, 0.0f, 0.5f
               [NSArray arrayWithObjects:@"navy1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"navy0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"navy0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"navy0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"navy0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.2f],     nil],

               // blue 0.0f, 0.0f, 1.0f
               [NSArray arrayWithObjects:@"blue1.0",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"blue0.8",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"blue0.6",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"blue0.4",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"blue0.2",     [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.2f],     nil],

               // purple 0.5f, 0.0f, 0.5f
               [NSArray arrayWithObjects:@"purple1.0",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"purple0.8",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"purple0.6",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"purple0.4",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"purple0.2",     [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.2f],     nil],

               // fuchsia 1.0f, 0.0f, 1.0f
               [NSArray arrayWithObjects:@"fuchsia1.0",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:1.0f],     nil],
               [NSArray arrayWithObjects:@"fuchsia0.8",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.8f],     nil],
               [NSArray arrayWithObjects:@"fuchsia0.6",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.6f],     nil],
               [NSArray arrayWithObjects:@"fuchsia0.4",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.4f],     nil],
               [NSArray arrayWithObjects:@"fuchsia0.2",     [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.2f],     nil],
               nil];
    [colors_ retain];
  }

  return self;
}

- (void) setupMenu
{
  NSArray* menus = [NSArray arrayWithObjects:menu_color0_, menu_color1_, menu_color2_, nil];

  for (NSArray* nameAndColor in colors_) {
    NSString* name = [nameAndColor objectAtIndex:0];
    NSColor* color = [nameAndColor objectAtIndex:1];

    for (NSMenu* menu in menus) {
      NSMenuItem* newItem = [[[NSMenuItem alloc] initWithTitle:name action:NULL keyEquivalent:@""] autorelease];

      // ----------------------------------------
      // Add image icon
      enum {
        IMAGE_WIDTH = 40,
        IMAGE_HEIGHT = 16,
        BORDER_WIDTH = 2,
      };
      NSImage* newImage = [[[NSImage alloc] initWithSize:NSMakeSize(IMAGE_WIDTH, IMAGE_HEIGHT)] autorelease];
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

  [tableview_ reloadData];
}

static NSInteger
compareDictionary(NSDictionary* dict1, NSDictionary* dict2, void* context)
{
  NSString* string1 = [dict1 objectForKey:@"inputsourceid"];
  NSString* string2 = [dict2 objectForKey:@"inputsourceid"];
  return [string1 compare:string2];
}

- (void) sort
{
  [data_ sortUsingFunction:compareDictionary context:NULL];
}

- (void) load
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSArray* saveddata = [defaults arrayForKey:@"CustomizedLanguageColor"];

  for (NSDictionary* dict in saveddata) {
    [data_ addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
  }

  [self sort];
  [tableview_ reloadData];
}

- (void) save
{
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:data_ forKey:@"CustomizedLanguageColor"];
  [defaults synchronize];
}

- (void) add:(NSString*)newInputSourceID
{
  // unique check
  for (NSDictionary* dict in data_) {
    NSString* name = [dict objectForKey:@"inputsourceid"];
    if ([name isEqual:newInputSourceID]) goto added;
  }

  {
    NSArray* keys = [NSArray arrayWithObjects:@"inputsourceid", @"color0", @"color1", @"color2", nil];
    NSArray* objects = [NSArray arrayWithObjects:newInputSourceID, @"white", @"white", @"white", nil];
    [data_ addObject:[NSMutableDictionary dictionaryWithObjects:objects forKeys:keys]];
  }

added:
  [self sort];
  // call reloadData once before selectRowIndexes.
  [tableview_ reloadData];

  NSUInteger rowIndex = 0;
  for (NSDictionary* dict in data_) {
    NSString* name = [dict objectForKey:@"inputsourceid"];
    if ([name isEqual:newInputSourceID]) {
      [tableview_ selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
      [tableview_ scrollRowToVisible:rowIndex];
      break;
    }
    ++rowIndex;
  }

  [tableview_ reloadData];
  [self save];
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];
}

- (void) remove
{
  NSInteger rowIndex = [tableview_ selectedRow];
  if (rowIndex == -1) return;

  [data_ removeObjectAtIndex:rowIndex];
  [tableview_ reloadData];
  [self save];
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];
}

- (NSDictionary*) getDictionaryFromInputSourceID:(NSString*)inputsourceid
{
  for (NSDictionary* dict in data_) {
    NSString* name = [dict objectForKey:@"inputsourceid"];
    if ([name isEqual:inputsourceid]) {
      return dict;
    }
  }
  return nil;
}

- (NSColor*) getColorFromName:(NSString*)colorName
{
  for (NSArray* nameAndColor in colors_) {
    NSString* name = [nameAndColor objectAtIndex:0];
    NSColor* color = [nameAndColor objectAtIndex:1];
    if ([name isEqual:colorName]) {
      return color;
    }
  }
  return nil;
}

// ----------------------------------------------------------------------
- (NSInteger) numberOfRowsInTableView:(NSTableView*)aTableView
{
  return [data_ count];
}

- (id) tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)rowIndex
{
  NSString* identifier = [aTableColumn identifier];
  NSDictionary* dict = [data_ objectAtIndex:rowIndex];
  NSString* value = [dict objectForKey:identifier];

  if ([identifier isEqual:@"inputsourceid"]) {
    return value;
  }

  if ([identifier isEqual:@"color0"] ||
      [identifier isEqual:@"color1"] ||
      [identifier isEqual:@"color2"]) {
    int i = 0;
    for (NSArray* nameAndColor in colors_) {
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
    NSArray* nameAndColor = [colors_ objectAtIndex:[anObject integerValue]];
    NSString* name = [nameAndColor objectAtIndex:0];

    NSMutableDictionary* dict = [data_ objectAtIndex:rowIndex];
    [dict setObject:name forKey:identifier];

    [self save];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorColorChangedNotification object:nil userInfo:nil]];

    return;
  }
}

@end
