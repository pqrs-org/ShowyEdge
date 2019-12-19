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

@interface PreferencesModel : NSObject <NSCoding>

@property BOOL resumeAtLogin;
@property BOOL checkForUpdates;

@property(copy) NSArray* inputSourceColors;

@property CGFloat indicatorHeight;
@property NSInteger indicatorOpacity;
@property(copy) NSString* colorsLayoutOrientation;

@property BOOL useCustomFrame;
@property NSInteger customFrameOrigin;
@property NSInteger customFrameLeft;
@property NSInteger customFrameTop;
@property NSInteger customFrameWidth;
@property NSInteger customFrameWidthUnit;
@property NSInteger customFrameHeight;
@property NSInteger customFrameHeightUnit;

@property BOOL hideInFullScreenSpace;
@property BOOL showIndicatorBehindAppWindows;

- (void)addInputSourceID:(NSString*)inputSourceID;
- (void)removeInputSourceID:(NSString*)inputSourceID;
- (void)changeColor:(NSString*)inputSourceID key:(NSString*)key color:(NSString*)color;

- (NSInteger)getIndexOfInputSourceID:(NSString*)inputSourceID;
- (NSArray*)getColorsFromInputSourceID:(NSString*)inputSourceID;

@end
