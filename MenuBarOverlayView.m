/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "MenuBarOverlayView.h"
#import "PreferencesController.h"

@implementation MenuBarOverlayView

- (void) drawRect:(NSRect)rect {
  if (! color0_) return;
  if (! color1_) return;
  if (! color2_) return;

  NSRect fullrect = [self frame];

  CGFloat width = fullrect.size.width / 3;

  [[NSColor redColor] set];
  NSRectFill(NSMakeRect(0, 0, 0, fullrect.size.height));

  [color0_ set];
  NSRectFill(NSMakeRect(width * 0, 0, width * 1, fullrect.size.height));

  [color1_ set];
  NSRectFill(NSMakeRect(width * 1, 0, width * 2, fullrect.size.height));

  [color2_ set];
  NSRectFill(NSMakeRect(width * 2, 0, width * 3, fullrect.size.height));
}

- (void) adjustFrame {
  [self setFrame:NSMakeRect(0,
                            0,
                            [PreferencesController indicatorWidth],
                            [PreferencesController indicatorHeight])];
}

- (void) setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2
{
  color0_ = c0;
  color1_ = c1;
  color2_ = c2;
  [self display];
}

@end
