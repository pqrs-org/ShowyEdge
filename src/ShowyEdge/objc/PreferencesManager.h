// -*- mode: objective-c -*-

@import Cocoa;

enum CustomFrameOrigin {
  // This value is saved into NSUserDefaults.
  // Do not change existing values.

  CustomFrameOriginUpperLeft = 0,
  CustomFrameOriginLowerLeft = 1,
  CustomFrameOriginUpperRight = 2,
  CustomFrameOriginLowerRight = 3,
};

enum CustomFrameUnit {
  // This value is saved into NSUserDefaults.
  // Do not change existing values.

  CustomFrameUnitPixel = 0,
  CustomFrameUnitPercent = 1,
};

@interface PreferencesManager : NSObject

+ (NSArray*)customizedLanguageColors;
+ (void)addCustomizedLanguageColor:(NSString*)inputSourceId;
+ (void)changeCustomizedLanguageColor:(NSString*)inputSourceId key:(NSString*)key color:(NSString*)color;
+ (void)removeCustomizedLanguageColor:(NSString*)inputSourceId;
+ (NSInteger)getCustomizedLanguageColorIndexByInputSourceId:(NSString*)inputSourceId;
+ (NSArray*)getCustomizedLanguageColorByInputSourceId:(NSString*)inputSourceId;

+ (NSString*)colorsLayoutOrientation;
+ (NSInteger)customFrameOrigin;
+ (NSInteger)customFrameTop;
+ (NSInteger)customFrameLeft;
+ (NSInteger)customFrameWidth;
+ (NSInteger)customFrameWidthUnit;
+ (NSInteger)customFrameHeight;
+ (NSInteger)customFrameHeightUnit;
+ (BOOL)hideInFullScreenSpace;
+ (CGFloat)indicatorHeightPx;
+ (NSInteger)indicatorOpacity;
+ (BOOL)showIconInMenubar;
+ (BOOL)showIndicatorBehindAppWindows;
+ (BOOL)useCustomFrame;

@end
