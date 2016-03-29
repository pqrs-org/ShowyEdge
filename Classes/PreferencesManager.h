// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@interface PreferencesManager : NSObject

@property(copy, readonly) NSArray* colors;

- (BOOL)isCheckForUpdates;
- (CGFloat)indicatorHeight;
- (NSArray*)getColorsFromInputSourceID:(NSString*)inputsourceid;
- (void)addInputSourceID:(NSString*)inputsourceid;

@end