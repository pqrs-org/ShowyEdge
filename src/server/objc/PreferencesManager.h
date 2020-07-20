// -*- mode: objective-c -*-

@import Cocoa;

@class PreferencesModel;

@interface PreferencesManager : NSObject

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel;
- (void)savePreferencesModel:(PreferencesModel*)preferencesModel processIdentifier:(int)processIdentifier;

@end
