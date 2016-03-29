#import "PreferencesKeys.h"
#import "PreferencesManager.h"

@interface PreferencesManager ()

@property(copy, readwrite) NSArray* colors;

@end

@implementation PreferencesManager

+ (void)initialize {
  NSDictionary* dict = @{
    kIndicatorHeight : @"0.25",
    kIndicatorOpacity : @50,
    kShowIconInDock : @NO,
    kUseCustomFrame : @NO,
    kCustomFrameTop : @0,
    kCustomFrameLeft : @0,
    kCustomFrameWidth : @100,
    kCustomFrameHeight : @100,
    kColorsLayoutOrientation : @"horizontal",
  };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (instancetype)init {
  self = [super init];

  if (self) {
    self.colors = @[
      // We use grayColor as "black" because blackColor is too dark.
      @[ @"black", [NSColor grayColor] ],
      @[ @"blue", [NSColor blueColor] ],
      @[ @"brown", [NSColor brownColor] ],
      @[ @"clear", [NSColor clearColor] ],
      @[ @"cyan", [NSColor cyanColor] ],
      @[ @"green", [NSColor greenColor] ],
      @[ @"magenta", [NSColor magentaColor] ],
      @[ @"orange", [NSColor orangeColor] ],
      @[ @"purple", [NSColor purpleColor] ],
      @[ @"red", [NSColor redColor] ],
      @[ @"white", [NSColor whiteColor] ],
      @[ @"yellow", [NSColor yellowColor] ],

      // ------------------------------------------------------------
      // more colors
      // black 0.0f, 0.0f, 0.0f
      @[ @"black1.0", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f] ],
      @[ @"black0.8", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.8f] ],
      @[ @"black0.6", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.6f] ],
      @[ @"black0.4", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.4f] ],
      @[ @"black0.2", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.2f] ],

      // gray 0.5f, 0.5f, 0.5f
      @[ @"gray1.0", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:1.0f] ],
      @[ @"gray0.8", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.8f] ],
      @[ @"gray0.6", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.6f] ],
      @[ @"gray0.4", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.4f] ],
      @[ @"gray0.2", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.2f] ],

      // silver 0.75f, 0.75f, 0.75f
      @[ @"silver1.0", [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:1.0f] ],
      @[ @"silver0.8", [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.8f] ],
      @[ @"silver0.6", [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.6f] ],
      @[ @"silver0.4", [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.4f] ],
      @[ @"silver0.2", [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.2f] ],

      // white 1.0f, 1.0f, 1.0f
      @[ @"white1.0", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f] ],
      @[ @"white0.8", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.8f] ],
      @[ @"white0.6", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.6f] ],
      @[ @"white0.4", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.4f] ],
      @[ @"white0.2", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.2f] ],

      // maroon 0.5f, 0.0f, 0.0f
      @[ @"maroon1.0", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:1.0f] ],
      @[ @"maroon0.8", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.8f] ],
      @[ @"maroon0.6", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.6f] ],
      @[ @"maroon0.4", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.4f] ],
      @[ @"maroon0.2", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.2f] ],

      // red 1.0f, 0.0f, 0.0f
      @[ @"red1.0", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:1.0f] ],
      @[ @"red0.8", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.8f] ],
      @[ @"red0.6", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.6f] ],
      @[ @"red0.4", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.4f] ],
      @[ @"red0.2", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.2f] ],

      // olive 0.5f, 0.5f, 0.0f
      @[ @"olive1.0", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:1.0f] ],
      @[ @"olive0.8", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.8f] ],
      @[ @"olive0.6", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.6f] ],
      @[ @"olive0.4", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.4f] ],
      @[ @"olive0.2", [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.2f] ],

      // yellow 1.0f, 1.0f, 0.0f
      @[ @"yellow1.0", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:1.0f] ],
      @[ @"yellow0.8", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.8f] ],
      @[ @"yellow0.6", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.6f] ],
      @[ @"yellow0.4", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.4f] ],
      @[ @"yellow0.2", [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.2f] ],

      // green 0.0f, 0.5f, 0.0f
      @[ @"green1.0", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:1.0f] ],
      @[ @"green0.8", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.8f] ],
      @[ @"green0.6", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.6f] ],
      @[ @"green0.4", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.4f] ],
      @[ @"green0.2", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.2f] ],

      // lime 0.0f, 1.0f, 0.0f
      @[ @"lime1.0", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:1.0f] ],
      @[ @"lime0.8", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.8f] ],
      @[ @"lime0.6", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.6f] ],
      @[ @"lime0.4", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.4f] ],
      @[ @"lime0.2", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.2f] ],

      // teal 0.0f, 0.5f, 0.5f
      @[ @"teal1.0", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:1.0f] ],
      @[ @"teal0.8", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.8f] ],
      @[ @"teal0.6", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.6f] ],
      @[ @"teal0.4", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.4f] ],
      @[ @"teal0.2", [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.2f] ],

      // aqua 0.0f, 1.0f, 1.0f
      @[ @"aqua1.0", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:1.0f] ],
      @[ @"aqua0.8", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.8f] ],
      @[ @"aqua0.6", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.6f] ],
      @[ @"aqua0.4", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.4f] ],
      @[ @"aqua0.2", [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.2f] ],

      // navy 0.0f, 0.0f, 0.5f
      @[ @"navy1.0", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:1.0f] ],
      @[ @"navy0.8", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.8f] ],
      @[ @"navy0.6", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.6f] ],
      @[ @"navy0.4", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.4f] ],
      @[ @"navy0.2", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.2f] ],

      // blue 0.0f, 0.0f, 1.0f
      @[ @"blue1.0", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:1.0f] ],
      @[ @"blue0.8", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.8f] ],
      @[ @"blue0.6", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.6f] ],
      @[ @"blue0.4", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.4f] ],
      @[ @"blue0.2", [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.2f] ],

      // purple 0.5f, 0.0f, 0.5f
      @[ @"purple1.0", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:1.0f] ],
      @[ @"purple0.8", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.8f] ],
      @[ @"purple0.6", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.6f] ],
      @[ @"purple0.4", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.4f] ],
      @[ @"purple0.2", [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.2f] ],

      // fuchsia 1.0f, 0.0f, 1.0f
      @[ @"fuchsia1.0", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:1.0f] ],
      @[ @"fuchsia0.8", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.8f] ],
      @[ @"fuchsia0.6", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.6f] ],
      @[ @"fuchsia0.4", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.4f] ],
      @[ @"fuchsia0.2", [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.2f] ],
    ];
  }

  return self;
}

- (BOOL)isCheckForUpdates {
  return YES;
}

- (CGFloat)indicatorHeight {
  CGFloat height = [[NSApp mainMenu] menuBarHeight];
  CGFloat factor = [[[NSUserDefaults standardUserDefaults] stringForKey:kIndicatorHeight] floatValue];
  height *= factor;

  NSRect rect = [[NSScreen mainScreen] frame];
  if (height > rect.size.height) {
    height = rect.size.height;
  }

  return height;
}

- (NSColor*)getColorFromName:(NSString*)colorName {
  for (NSArray* nameAndColor in self.colors) {
    NSString* name = nameAndColor[0];
    NSColor* color = nameAndColor[1];
    if ([name isEqual:colorName]) {
      return color;
    }
  }
  return [NSColor clearColor];
}

- (NSArray*)getColorsFromInputSourceID:(NSString*)inputsourceid {
  if (!inputsourceid) {
    return nil;
  }

  for (NSDictionary* dict in [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]) {
    if ([inputsourceid isEqualToString:dict[@"inputsourceid"]]) {
      return @[
        [self getColorFromName:dict[@"color0"]],
        [self getColorFromName:dict[@"color1"]],
        [self getColorFromName:dict[@"color2"]],
      ];
    }
  }

  return nil;
}

static NSInteger compareDictionary(NSDictionary* dict1, NSDictionary* dict2, void* context) {
  return [dict1[@"inputsourceid"] compare:dict2[@"inputsourceid"]];
}

- (void)addInputSourceID:(NSString*)inputsourceid {
  if ([self getColorsFromInputSourceID:inputsourceid]) {
    return;
  }

  NSMutableArray* dictionaries = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]];
  [dictionaries addObject:@{
    @"inputsourceid" : inputsourceid,
    @"color0" : @"white",
    @"color1" : @"white",
    @"color2" : @"white",
  }];

  [dictionaries sortUsingFunction:compareDictionary context:NULL];
  [[NSUserDefaults standardUserDefaults] setObject:dictionaries forKey:kCustomizedLanguageColor];

  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorConfigurationChangedNotification object:nil]];
}

@end
