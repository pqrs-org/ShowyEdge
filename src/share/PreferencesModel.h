// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@interface PreferencesModel : NSObject

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

- (void)addInputSourceID:(NSString*)inputSourceID;
- (void)removeInputSourceID:(NSString*)inputSourceID;
- (void)changeColor:(NSString*)inputSourceID key:(NSString*)key color:(NSString*)color;

- (NSArray*)getColorsFromInputSourceID:(NSString*)inputSourceID;

@end
