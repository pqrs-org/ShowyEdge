/* -*- mode: objective-c -*- */

@import Cocoa;

@class PreferencesModel;

@interface MenuBarOverlayView : NSView

@property(readonly) CGFloat adjustHeight;
@property(weak) PreferencesModel* preferencesModel;

- (void)setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2;

@end
