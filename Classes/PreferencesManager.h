// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@interface PreferencesManager : NSObject

@property(copy, readonly) NSArray* colors;

- (BOOL)isCheckForUpdates;
- (CGFloat)indicatorHeight;
- (NSArray*)getColorsFromInputSourceID:(NSString*)inputsourceid;
- (NSUInteger)addInputSourceID:(NSString*)inputsourceid;
- (void)removeInputSourceID:(NSString*)inputsourceid;
- (void)changeColor:(NSString*)inputsourceid key:(NSString*)key color:(NSString*)color;
- (NSColor*)colorFromString:(NSString*)color;

@end
