/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import <Cocoa/Cocoa.h>

@interface MenuBarOverlayView : NSView {
  NSColor* color0_;
  NSColor* color1_;
  NSColor* color2_;
}

- (void) initializeFrame;
- (void) setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2;

@end
