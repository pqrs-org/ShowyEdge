// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@class PreferencesModel;

@interface PreferencesClient : NSObject

@property PreferencesModel* pm;

- (void)load;
- (void)save;

@end
