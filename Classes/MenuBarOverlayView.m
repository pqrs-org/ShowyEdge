/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */

#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
#import "PreferencesController.h"
#import "PreferencesKeys.h"

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
  CGFloat margin = 10;

  // To avoid a gap between each colors, we specify "width + margin" as color bar width.
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
  // Therefore, we need to draw color bars by width + margin x fullrect.size.height.
  //
  //   |-----------------------|
  //                        |-----------------------|
  //                                             |-----------------------|
  //    Red                  Green                Blue

  [self.color0 set];
  NSRectFill(NSMakeRect(width * 0, 0, width + margin, fullrect.size.height));

  [self.color1 set];
  NSRectFill(NSMakeRect(width * 1, 0, width + margin, fullrect.size.height));

  [self.color2 set];
  NSRectFill(NSMakeRect(width * 2, 0, width + margin, fullrect.size.height));
}

- (void) setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2
{
  CGFloat opacity = [[NSUserDefaults standardUserDefaults] integerForKey:kIndicatorOpacity] / 100.0f;

  self.color0 = [c0 colorWithAlphaComponent:(opacity* [c0 alphaComponent])];
  self.color1 = [c1 colorWithAlphaComponent:(opacity* [c1 alphaComponent])];
  self.color2 = [c2 colorWithAlphaComponent:(opacity* [c2 alphaComponent])];
  [self display];
}

@end
