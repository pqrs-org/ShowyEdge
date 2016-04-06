#import "ColorUtilities.h"
#import "PreferencesModel.h"

@implementation PreferencesModel

static NSInteger compareDictionary(NSDictionary* dict1, NSDictionary* dict2, void* context) {
  return [dict1[@"inputsourceid"] compare:dict2[@"inputsourceid"]];
}

- (void)addInputSourceID:(NSString*)inputSourceID {
  if ([inputSourceID length] == 0) {
    return;
  }

  if ([self getColorsFromInputSourceID:inputSourceID]) {
    return;
  }

  NSMutableArray* colors = [NSMutableArray arrayWithArray:self.inputSourceColors];
  [colors addObject:@{
    @"inputsourceid" : inputSourceID,
    @"color0" : @"#ff0000ff",
    @"color1" : @"#ff0000ff",
    @"color2" : @"#ff0000ff",
  }];
  [colors sortUsingFunction:compareDictionary context:NULL];
  self.inputSourceColors = colors;
}

- (void)removeInputSourceID:(NSString*)inputSourceID {
  NSMutableArray* colors = [NSMutableArray arrayWithArray:self.inputSourceColors];
  for (NSUInteger i = 0; i < [colors count]; ++i) {
    if ([colors[i][@"inputsourceid"] isEqualToString:inputSourceID]) {
      [colors removeObjectAtIndex:i];
      break;
    }
  }
  self.inputSourceColors = colors;
}

- (void)changeColor:(NSString*)inputSourceID key:(NSString*)key color:(NSString*)color {
  NSMutableArray* colors = [NSMutableArray arrayWithArray:self.inputSourceColors];
  for (NSUInteger i = 0; i < [colors count]; ++i) {
    if ([colors[i][@"inputsourceid"] isEqualToString:inputSourceID]) {
      NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:colors[i]];
      d[key] = color;
      colors[i] = d;
      break;
    }
  }
  self.inputSourceColors = colors;
}

- (NSInteger)getIndexOfInputSourceID:(NSString*)inputSourceID {
  NSInteger index = 0;
  for (NSDictionary* dict in self.inputSourceColors) {
    if ([dict[@"inputsourceid"] isEqualToString:inputSourceID]) {
      return index;
    }
    ++index;
  }
  return -1;
}

- (NSArray*)getColorsFromInputSourceID:(NSString*)inputSourceID {
  NSInteger index = [self getIndexOfInputSourceID:inputSourceID];
  if (index < 0) {
    return nil;
  }
  NSDictionary* dict = self.inputSourceColors[index];
  return @[
    [ColorUtilities colorFromString:dict[@"color0"]],
    [ColorUtilities colorFromString:dict[@"color1"]],
    [ColorUtilities colorFromString:dict[@"color2"]],
  ];
}

@end
