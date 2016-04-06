#import "ColorUtilities.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "PreferencesModel.h"

@implementation PreferencesManager

+ (void)initialize {
  NSDictionary* dict = @{
    kIndicatorHeight : @"0.15",
    kIndicatorOpacity : @100,
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

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel {
  preferencesModel.resumeAtLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kResumeAtLogin];

  preferencesModel.inputSourceColors = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor];

  preferencesModel.indicatorHeight = [[NSUserDefaults standardUserDefaults] floatForKey:kIndicatorHeight];
  preferencesModel.indicatorOpacity = [[NSUserDefaults standardUserDefaults] integerForKey:kIndicatorOpacity];
  preferencesModel.colorsLayoutOrientation = [[NSUserDefaults standardUserDefaults] stringForKey:kColorsLayoutOrientation];

  preferencesModel.useCustomFrame = [[NSUserDefaults standardUserDefaults] boolForKey:kUseCustomFrame];
  preferencesModel.customFrameLeft = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameLeft];
  preferencesModel.customFrameTop = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameTop];
  preferencesModel.customFrameWidth = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameWidth];
  preferencesModel.customFrameHeight = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameHeight];
}

- (void)savePreferencesModel:(PreferencesModel*)preferencesModel {
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.resumeAtLogin) forKey:kResumeAtLogin];

  [[NSUserDefaults standardUserDefaults] setObject:preferencesModel.inputSourceColors forKey:kCustomizedLanguageColor];

  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.indicatorHeight) forKey:kIndicatorHeight];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.indicatorOpacity) forKey:kIndicatorOpacity];
  [[NSUserDefaults standardUserDefaults] setObject:preferencesModel.colorsLayoutOrientation forKey:kColorsLayoutOrientation];

  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.useCustomFrame) forKey:kUseCustomFrame];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameLeft) forKey:kCustomFrameLeft];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameTop) forKey:kCustomFrameTop];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameWidth) forKey:kCustomFrameWidth];
  [[NSUserDefaults standardUserDefaults] setObject:@(preferencesModel.customFrameHeight) forKey:kCustomFrameHeight];
}

- (BOOL)isCheckForUpdates {
  return YES;
}

- (CGFloat)indicatorHeight {
  CGFloat height = [[NSApp mainMenu] menuBarHeight];
  CGFloat factor = [[NSUserDefaults standardUserDefaults] floatForKey:kIndicatorHeight];
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
        [ColorUtilities colorFromString:dict[@"color0"]],
        [ColorUtilities colorFromString:dict[@"color1"]],
        [ColorUtilities colorFromString:dict[@"color2"]],
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

@end
