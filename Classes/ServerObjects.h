/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

@import Cocoa;

@class PreferencesManager;
@class Updater;
@class WorkSpaceData;

@interface ServerObjects : NSObject

@property(weak) IBOutlet PreferencesManager* preferencesManager;
@property(weak) IBOutlet Updater* updater;
@property(weak) IBOutlet WorkSpaceData* workSpaceData;

@end
