// -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*-

@import Cocoa;

@protocol ServerClientProtocol

@property(copy, readonly) NSString* currentInputSourceID;
@property(copy, readonly) NSString* currentInputModeID;

@end
