/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
#import "PreferencesController.h"

@interface MenuBarOverlayView ()

@property (nonatomic, strong) NSColor* color0;
@property (nonatomic, strong) NSColor* color1;
@property (nonatomic, strong) NSColor* color2;

@end

@implementation MenuBarOverlayView

- (void) drawRect:(NSRect)rect {
  if (! self.color0) return;
  if (! self.color1) return;
  if (! self.color2) return;

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

  [self.color0 set];
  NSRectFill(NSMakeRect(width * 0, 0, width * 1.2, fullrect.size.height));

  [self.color1 set];
  NSRectFill(NSMakeRect(width * 1, 0, width * 1.2, fullrect.size.height));

  [self.color2 set];
  NSRectFill(NSMakeRect(width * 2, 0, width * 1.2, fullrect.size.height));
}

- (void) setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2
{
  self.color0 = c0;
  self.color1 = c1;
  self.color2 = c2;
  [self display];
}

@end
