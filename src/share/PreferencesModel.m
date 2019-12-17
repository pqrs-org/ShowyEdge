#import "PreferencesModel.h"
#import "ColorUtilities.h"

#define DECODE_BOOL(KEY) _##KEY = [decoder decodeBoolForKey:@ #KEY];
#define DECODE_FLOAT(KEY) _##KEY = [decoder decodeFloatForKey:@ #KEY];
#define DECODE_INTEGER(KEY) _##KEY = [decoder decodeIntegerForKey:@ #KEY];
#define DECODE_OBJECT(KEY) _##KEY = [decoder decodeObjectForKey:@ #KEY];

#define ENCODE_BOOL(KEY) [encoder encodeBool:self.KEY forKey:@ #KEY];
#define ENCODE_FLOAT(KEY) [encoder encodeFloat:self.KEY forKey:@ #KEY];
#define ENCODE_INTEGER(KEY) [encoder encodeInteger:self.KEY forKey:@ #KEY];
#define ENCODE_OBJECT(KEY) [encoder encodeObject:self.KEY forKey:@ #KEY];

@implementation PreferencesModel

#pragma mark - NSObject

- (id)replacementObjectForPortCoder:(NSPortCoder*)encoder {
  if ([encoder isBycopy]) return self;
  return [super replacementObjectForPortCoder:encoder];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder*)decoder {
  self = [super init];

  if (self) {
    DECODE_BOOL(resumeAtLogin);
    DECODE_BOOL(checkForUpdates);

    DECODE_OBJECT(inputSourceColors);

    DECODE_FLOAT(indicatorHeight);
    DECODE_INTEGER(indicatorOpacity);
    DECODE_OBJECT(colorsLayoutOrientation);

    DECODE_BOOL(useCustomFrame);
    DECODE_INTEGER(customFrameLeft);
    DECODE_INTEGER(customFrameTop);
    DECODE_INTEGER(customFrameWidth);
    DECODE_INTEGER(customFrameHeight);

    DECODE_BOOL(hideInFullScreenSpace);
    DECODE_BOOL(showIndicatorBehindAppWindows);
  }

  return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
  ENCODE_BOOL(resumeAtLogin);
  ENCODE_BOOL(checkForUpdates);

  ENCODE_OBJECT(inputSourceColors);

  ENCODE_FLOAT(indicatorHeight);
  ENCODE_INTEGER(indicatorOpacity);
  ENCODE_OBJECT(colorsLayoutOrientation);

  ENCODE_BOOL(useCustomFrame);
  ENCODE_INTEGER(customFrameLeft);
  ENCODE_INTEGER(customFrameTop);
  ENCODE_INTEGER(customFrameWidth);
  ENCODE_INTEGER(customFrameHeight);

  ENCODE_BOOL(hideInFullScreenSpace);
  ENCODE_BOOL(showIndicatorBehindAppWindows);
}

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
