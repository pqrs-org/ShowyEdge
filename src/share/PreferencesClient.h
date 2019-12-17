// -*- mode: objective-c -*-

@import Cocoa;

@class PreferencesModel;

@interface PreferencesClient : NSObject

@property PreferencesModel* pm;

- (void)load;
- (void)save;

@end
