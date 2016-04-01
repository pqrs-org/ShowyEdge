#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"

@implementation PreferencesManager

+ (void)initialize {
  NSDictionary* dict = @{
    kIndicatorHeight : @"0.25",
    kIndicatorOpacity : @50,
    kShowIconInDock : @NO,
    kResumeAtLogin : @YES,
    kUseCustomFrame : @NO,
    kCustomFrameTop : @0,
    kCustomFrameLeft : @0,
    kCustomFrameWidth : @100,
    kCustomFrameHeight : @100,
    kColorsLayoutOrientation : @"horizontal",
  };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (BOOL)isCheckForUpdates {
  return YES;
}

- (BOOL)isRelaunchAfterClosingPreferencesWindow {
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

- (NSArray*)getColorsFromInputSourceID:(NSString*)inputsourceid {
  if (!inputsourceid) {
    return nil;
  }

  for (NSDictionary* dict in [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]) {
    if ([inputsourceid isEqualToString:dict[@"inputsourceid"]]) {
      return @[
        [self colorFromString:dict[@"color0"]],
        [self colorFromString:dict[@"color1"]],
        [self colorFromString:dict[@"color2"]],
      ];
    }
  }

  return nil;
}

static NSInteger compareDictionary(NSDictionary* dict1, NSDictionary* dict2, void* context) {
  return [dict1[@"inputsourceid"] compare:dict2[@"inputsourceid"]];
}

- (NSUInteger)addInputSourceID:(NSString*)inputsourceid {
  if ([inputsourceid length] == 0) {
    return 0;
  }

  if (![self getColorsFromInputSourceID:inputsourceid]) {
    NSMutableArray* dictionaries = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]];
    [dictionaries addObject:@{
      @"inputsourceid" : inputsourceid,
      @"color0" : @"#ff0000ff",
      @"color1" : @"#ff0000ff",
      @"color2" : @"#ff0000ff",
    }];

    [dictionaries sortUsingFunction:compareDictionary context:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:dictionaries forKey:kCustomizedLanguageColor];

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorConfigurationChangedNotification object:nil]];
  }

  NSArray* a = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor];
  for (NSUInteger i = 0; i < [a count]; ++i) {
    if ([inputsourceid isEqualToString:a[i][@"inputsourceid"]]) {
      return i;
    }
  }
  return 0;
}

- (void)removeInputSourceID:(NSString*)inputsourceid {
  NSMutableArray* dictionaries = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]];
  for (NSUInteger i = 0; i < [dictionaries count]; ++i) {
    if ([dictionaries[i][@"inputsourceid"] isEqualToString:inputsourceid]) {
      [dictionaries removeObjectAtIndex:i];
      break;
    }
  }
  [[NSUserDefaults standardUserDefaults] setObject:dictionaries forKey:kCustomizedLanguageColor];

  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorConfigurationChangedNotification object:nil]];
}

- (void)changeColor:(NSString*)inputsourceid key:(NSString*)key color:(NSString*)color {
  NSMutableArray* dictionaries = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor]];
  for (NSUInteger i = 0; i < [dictionaries count]; ++i) {
    if ([dictionaries[i][@"inputsourceid"] isEqualToString:inputsourceid]) {
      NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:dictionaries[i]];
      d[key] = color;
      dictionaries[i] = d;
      break;
    }
  }
  [[NSUserDefaults standardUserDefaults] setObject:dictionaries forKey:kCustomizedLanguageColor];

  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kIndicatorConfigurationChangedNotification object:nil]];
}

- (NSColor*)colorFromString:(NSString*)color {
  if ([color hasPrefix:@"#"] && [color length] == 9) {
    // #RRGGBBAA

    NSString* sr = [NSString stringWithFormat:@"0x%@", [color substringWithRange:NSMakeRange(1, 2)]];
    NSString* sg = [NSString stringWithFormat:@"0x%@", [color substringWithRange:NSMakeRange(3, 2)]];
    NSString* sb = [NSString stringWithFormat:@"0x%@", [color substringWithRange:NSMakeRange(5, 2)]];
    NSString* sa = [NSString stringWithFormat:@"0x%@", [color substringWithRange:NSMakeRange(7, 2)]];

    float r, g, b, a;
    if ([[NSScanner scannerWithString:sr] scanHexFloat:&r] &&
        [[NSScanner scannerWithString:sg] scanHexFloat:&g] &&
        [[NSScanner scannerWithString:sb] scanHexFloat:&b] &&
        [[NSScanner scannerWithString:sa] scanHexFloat:&a]) {
      return [NSColor colorWithCalibratedRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:(a / 255.0f)];
    }

  } else {
    if ([@"black" isEqualToString:color]) {
      return [NSColor grayColor];
    }
    if ([@"blue" isEqualToString:color]) {
      return [NSColor blueColor];
    }
    if ([@"brown" isEqualToString:color]) {
      return [NSColor brownColor];
    }
    if ([@"clear" isEqualToString:color]) {
      return [NSColor clearColor];
    }
    if ([@"cyan" isEqualToString:color]) {
      return [NSColor cyanColor];
    }
    if ([@"green" isEqualToString:color]) {
      return [NSColor greenColor];
    }
    if ([@"magenta" isEqualToString:color]) {
      return [NSColor magentaColor];
    }
    if ([@"orange" isEqualToString:color]) {
      return [NSColor orangeColor];
    }
    if ([@"purple" isEqualToString:color]) {
      return [NSColor purpleColor];
    }
    if ([@"red" isEqualToString:color]) {
      return [NSColor redColor];
    }
    if ([@"white" isEqualToString:color]) {
      return [NSColor whiteColor];
    }
    if ([@"yellow" isEqualToString:color]) {
      return [NSColor yellowColor];
    }

    // more colors

    // black 0.0f, 0.0f, 0.0f
    if ([@"black1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    if ([@"black0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    }
    if ([@"black0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    }
    if ([@"black0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    }
    if ([@"black0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    }

    // gray 0.5f, 0.5f, 0.5f
    if ([@"gray1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    }
    if ([@"gray0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.8f];
    }
    if ([@"gray0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.6f];
    }
    if ([@"gray0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.4f];
    }
    if ([@"gray0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.2f];
    }

    // silver 0.75f, 0.75f, 0.75f
    if ([@"silver1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
    }
    if ([@"silver0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.8f];
    }
    if ([@"silver0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.6f];
    }
    if ([@"silver0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.4f];
    }
    if ([@"silver0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.75f green:0.75f blue:0.75f alpha:0.2f];
    }

    // white 1.0f, 1.0f, 1.0f
    if ([@"white1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    if ([@"white0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    }
    if ([@"white0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.6f];
    }
    if ([@"white0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    }
    if ([@"white0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    }

    // maroon 0.5f, 0.0f, 0.0f
    if ([@"maroon1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:1.0f];
    }
    if ([@"maroon0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.8f];
    }
    if ([@"maroon0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.6f];
    }
    if ([@"maroon0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.4f];
    }
    if ([@"maroon0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.0f alpha:0.2f];
    }

    // red 1.0f, 0.0f, 0.0f
    if ([@"red1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    if ([@"red0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.8f];
    }
    if ([@"red0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.6f];
    }
    if ([@"red0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.4f];
    }
    if ([@"red0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.2f];
    }

    // olive 0.5f, 0.5f, 0.0f
    if ([@"olive1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:1.0f];
    }
    if ([@"olive0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.8f];
    }
    if ([@"olive0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.6f];
    }
    if ([@"olive0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.4f];
    }
    if ([@"olive0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.0f alpha:0.2f];
    }

    // yellow 1.0f, 1.0f, 0.0f
    if ([@"yellow1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:1.0f];
    }
    if ([@"yellow0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.8f];
    }
    if ([@"yellow0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.6f];
    }
    if ([@"yellow0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.4f];
    }
    if ([@"yellow0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.0f alpha:0.2f];
    }

    // green 0.0f, 0.5f, 0.0f
    if ([@"green1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
    }
    if ([@"green0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.8f];
    }
    if ([@"green0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.6f];
    }
    if ([@"green0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.4f];
    }
    if ([@"green0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.0f alpha:0.2f];
    }

    // lime 0.0f, 1.0f, 0.0f
    if ([@"lime1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:1.0f];
    }
    if ([@"lime0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.8f];
    }
    if ([@"lime0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.6f];
    }
    if ([@"lime0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.4f];
    }
    if ([@"lime0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.2f];
    }

    // teal 0.0f, 0.5f, 0.5f
    if ([@"teal1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:1.0f];
    }
    if ([@"teal0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.8f];
    }
    if ([@"teal0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.6f];
    }
    if ([@"teal0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.4f];
    }
    if ([@"teal0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.5f blue:0.5f alpha:0.2f];
    }

    // aqua 0.0f, 1.0f, 1.0f
    if ([@"aqua1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    if ([@"aqua0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.8f];
    }
    if ([@"aqua0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.6f];
    }
    if ([@"aqua0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.4f];
    }
    if ([@"aqua0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:1.0f alpha:0.2f];
    }

    // navy 0.0f, 0.0f, 0.5f
    if ([@"navy1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:1.0f];
    }
    if ([@"navy0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.8f];
    }
    if ([@"navy0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.6f];
    }
    if ([@"navy0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.4f];
    }
    if ([@"navy0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.5f alpha:0.2f];
    }

    // blue 0.0f, 0.0f, 1.0f
    if ([@"blue1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:1.0f];
    }
    if ([@"blue0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.8f];
    }
    if ([@"blue0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.6f];
    }
    if ([@"blue0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.4f];
    }
    if ([@"blue0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:0.2f];
    }

    // purple 0.5f, 0.0f, 0.5f
    if ([@"purple1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:1.0f];
    }
    if ([@"purple0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.8f];
    }
    if ([@"purple0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.6f];
    }
    if ([@"purple0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.4f];
    }
    if ([@"purple0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:0.5f green:0.0f blue:0.5f alpha:0.2f];
    }

    // fuchsia 1.0f, 0.0f, 1.0f
    if ([@"fuchsia1.0" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:1.0f];
    }
    if ([@"fuchsia0.8" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.8f];
    }
    if ([@"fuchsia0.6" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.6f];
    }
    if ([@"fuchsia0.4" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.4f];
    }
    if ([@"fuchsia0.2" isEqualToString:color]) {
      return [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:1.0f alpha:0.2f];
    }
  }

  return [NSColor clearColor];
}

@end
