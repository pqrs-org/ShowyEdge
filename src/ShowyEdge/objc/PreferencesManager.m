#import "PreferencesManager.h"
#import "ColorUtilities.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"

@implementation PreferencesManager

+ (void)initialize {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    NSDictionary* dict = @{
      kCustomFrameTop : @0,
      kCustomFrameWidth : @100,
      kCustomFrameWidthUnit : @0,
      kCustomFrameHeight : @100,
      kCustomFrameHeightUnit : @0,
      kCustomizedLanguageColor : @[],
      kColorsLayoutOrientation : @"horizontal",
      kHideInFullScreenSpace : @NO,
      kShowIndicatorBehindAppWindows : @NO,
    };
    [NSUserDefaults.standardUserDefaults registerDefaults:dict];
  });
}

+ (NSArray*)customizedLanguageColors {
  return [NSUserDefaults.standardUserDefaults arrayForKey:kCustomizedLanguageColor];
}

+ (void)addCustomizedLanguageColor:(NSString*)inputSourceId {
  if (inputSourceId.length == 0) {
    return;
  }

  if ([self getCustomizedLanguageColorIndexByInputSourceId:inputSourceId] != -1) {
    return;
  }

  NSMutableArray* colors = self.customizedLanguageColors.mutableCopy;

  [colors addObject:@{
    @"inputsourceid" : inputSourceId,
    @"color0" : @"#ff0000ff",
    @"color1" : @"#ff0000ff",
    @"color2" : @"#ff0000ff",
  }];

  [colors sortUsingComparator:^NSComparisonResult(NSDictionary* dict1, NSDictionary* dict2) {
    return [dict1[@"inputsourceid"] compare:dict2[@"inputsourceid"]];
  }];

  [NSUserDefaults.standardUserDefaults setObject:colors forKey:kCustomizedLanguageColor];
}

+ (void)changeCustomizedLanguageColor:(NSString*)inputSourceId key:(NSString*)key color:(NSString*)color {
  NSMutableArray* colors = self.customizedLanguageColors.mutableCopy;

  for (NSUInteger i = 0; i < colors.count; ++i) {
    if ([colors[i][@"inputsourceid"] isEqualToString:inputSourceId]) {
      NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:colors[i]];
      d[key] = color;
      colors[i] = d;
      break;
    }
  }

  [NSUserDefaults.standardUserDefaults setObject:colors forKey:kCustomizedLanguageColor];
}

+ (void)removeCustomizedLanguageColor:(NSString*)inputSourceId {
  NSMutableArray* colors = self.customizedLanguageColors.mutableCopy;

  for (NSUInteger i = 0; i < colors.count; ++i) {
    if ([colors[i][@"inputsourceid"] isEqualToString:inputSourceId]) {
      [colors removeObjectAtIndex:i];
      break;
    }
  }

  [NSUserDefaults.standardUserDefaults setObject:colors forKey:kCustomizedLanguageColor];
}

+ (NSInteger)getCustomizedLanguageColorIndexByInputSourceId:(NSString*)inputSourceId {
  NSArray* colors = self.customizedLanguageColors;

  NSInteger index = 0;
  for (NSDictionary* dict in colors) {
    if ([dict[@"inputsourceid"] isEqualToString:inputSourceId]) {
      return index;
    }
    ++index;
  }

  return -1;
}

+ (NSArray*)getCustomizedLanguageColorByInputSourceId:(NSString*)inputSourceId {
  NSArray* colors = self.customizedLanguageColors;

  for (NSDictionary* dict in colors) {
    if ([dict[@"inputsourceid"] isEqualToString:inputSourceId]) {
      return @[
        [ColorUtilities colorFromString:dict[@"color0"]],
        [ColorUtilities colorFromString:dict[@"color1"]],
        [ColorUtilities colorFromString:dict[@"color2"]],
      ];
    }
  }

  return nil;
}

+ (NSString*)colorsLayoutOrientation {
  return [NSUserDefaults.standardUserDefaults stringForKey:kColorsLayoutOrientation];
}

+ (NSInteger)customFrameTop {
  return [NSUserDefaults.standardUserDefaults integerForKey:kCustomFrameTop];
}

+ (NSInteger)customFrameWidth {
  return [NSUserDefaults.standardUserDefaults integerForKey:kCustomFrameWidth];
}

+ (NSInteger)customFrameWidthUnit {
  return [NSUserDefaults.standardUserDefaults integerForKey:kCustomFrameWidthUnit];
}

+ (NSInteger)customFrameHeight {
  return [NSUserDefaults.standardUserDefaults integerForKey:kCustomFrameHeight];
}

+ (NSInteger)customFrameHeightUnit {
  return [NSUserDefaults.standardUserDefaults integerForKey:kCustomFrameHeightUnit];
}

+ (BOOL)hideInFullScreenSpace {
  return [NSUserDefaults.standardUserDefaults boolForKey:kHideInFullScreenSpace];
}

+ (BOOL)showIndicatorBehindAppWindows {
  return [NSUserDefaults.standardUserDefaults boolForKey:kShowIndicatorBehindAppWindows];
}

@end
