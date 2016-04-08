// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@class PreferencesModel;

@protocol ServerClientProtocol

@property(copy, readonly) NSString* bundleVersion;
@property(copy, readonly) NSString* currentInputSourceID;
@property(copy, readonly) NSString* currentInputModeID;

- (void)loadPreferencesModel:(PreferencesModel*)preferencesModel;
- (void)savePreferencesModel:(PreferencesModel*)preferencesModel processIdentifier:(int)processIdentifier;
- (void)updateStartAtLogin;

- (void)terminateServerProcess;

- (void)checkForUpdatesStableOnly;
- (void)checkForUpdatesWithBetaVersion;

@end
