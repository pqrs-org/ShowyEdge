// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@class PreferencesModel;

@interface PreferencesManager : NSObject

@property(copy, readonly) NSArray* colors;

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel;
- (void)savePreferencesModel:(PreferencesModel*)preferencesModel;

- (BOOL)isCheckForUpdates;
- (CGFloat)indicatorHeight;
- (NSArray*)getColorsFromInputSourceID:(NSString*)inputsourceid;
- (NSUInteger)addInputSourceID:(NSString*)inputsourceid;
- (void)removeInputSourceID:(NSString*)inputsourceid;
- (void)changeColor:(NSString*)inputsourceid key:(NSString*)key color:(NSString*)color;
- (NSColor*)colorFromString:(NSString*)color;

@end
