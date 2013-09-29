/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
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

  // To avoid a gap between each colors, we specify "width * 1.2" as color bar width.
  //
  //
  // In the case that color configuration is "red, green, blue":
  //
  //   |--------------------|--------------------|--------------------|
  //    Red                  Green                Blue
  //
  // If we draw color bars by width x fullrect.size.height,
  // a gap will appear on some screen resolution.
  //
  //   |------------------| |------------------| |--------------------|
  //    Red                  Green                Blue
  //
  // Therefore, we need to draw color bars by width*1.2 x fullrect.size.height.
  //
  //   |-----------------------|
  //                        |-----------------------|
  //                                             |-----------------------|
  //    Red                  Green                Blue

  [color0_ set];
  NSRectFill(NSMakeRect(width * 0, 0, width * 1.2, fullrect.size.height));

  [color1_ set];
  NSRectFill(NSMakeRect(width * 1, 0, width * 1.2, fullrect.size.height));

  [color2_ set];
  NSRectFill(NSMakeRect(width * 2, 0, width * 1.2, fullrect.size.height));
}

- (void) setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2
{
  color0_ = c0;
  color1_ = c1;
  color2_ = c2;
  [self display];
}

@end
