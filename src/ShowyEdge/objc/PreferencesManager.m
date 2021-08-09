#import "PreferencesManager.h"
#import "ColorUtilities.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"

@implementation PreferencesManager

+ (void)initialize {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    NSDictionary* dict = @{
      kCustomizedLanguageColor : @[],
    };
    [NSUserDefaults.standardUserDefaults registerDefaults:dict];
  });
}

+ (NSArray*)customizedLanguageColors {
  return [NSUserDefaults.standardUserDefaults arrayForKey:kCustomizedLanguageColor];
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

@end
