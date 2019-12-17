// -*- mode: objective-c -*-

@import Cocoa;

@interface PreferencesModel : NSObject <NSCoding>

@property BOOL resumeAtLogin;
@property BOOL checkForUpdates;

@property(copy) NSArray* inputSourceColors;

@property CGFloat indicatorHeight;
@property NSInteger indicatorOpacity;
@property(copy) NSString* colorsLayoutOrientation;

@property BOOL useCustomFrame;
@property NSInteger customFrameLeft;
@property NSInteger customFrameTop;
@property NSInteger customFrameWidth;
@property NSInteger customFrameHeight;

@property BOOL hideInFullScreenSpace;
@property BOOL showIndicatorBehindAppWindows;

- (void)addInputSourceID:(NSString*)inputSourceID;
- (void)removeInputSourceID:(NSString*)inputSourceID;
- (void)changeColor:(NSString*)inputSourceID key:(NSString*)key color:(NSString*)color;

- (NSInteger)getIndexOfInputSourceID:(NSString*)inputSourceID;
- (NSArray*)getColorsFromInputSourceID:(NSString*)inputSourceID;

@end
