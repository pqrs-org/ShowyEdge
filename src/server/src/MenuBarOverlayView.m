/* -*- mode: objective-c -*- */

#import "MenuBarOverlayView.h"
#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesModel.h"

@interface MenuBarOverlayView ()

@property NSColor* color0;
@property NSColor* color1;
@property NSColor* color2;

@end

@implementation MenuBarOverlayView

- (CGFloat)adjustHeight {
  return 2.0;
}

- (void)drawRect:(NSRect)rect {
  if (!self.color0) return;
  if (!self.color1) return;
  if (!self.color2) return;

  NSRect fullrect = [self frame];

  BOOL isColorsLayoutOrientationHorizontal = [@"horizontal" isEqualToString:self.preferencesModel.colorsLayoutOrientation];

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

  if (isColorsLayoutOrientationHorizontal) {
    CGFloat width = fullrect.size.width / 3;

    [self.color0 set];
    NSRectFill(NSMakeRect(width * 0, 0, width + margin, fullrect.size.height));

    [self.color1 set];
    NSRectFill(NSMakeRect(width * 1, 0, width + margin, fullrect.size.height));

    [self.color2 set];
    NSRectFill(NSMakeRect(width * 2, 0, width + margin, fullrect.size.height));

  } else {
    CGFloat height = (fullrect.size.height - self.adjustHeight) / 3;

    [self.color2 set];
    NSRectFill(NSMakeRect(0, height * 0, fullrect.size.width, height + margin));

    [self.color1 set];
    NSRectFill(NSMakeRect(0, height * 1, fullrect.size.width, height + margin));

    [self.color0 set];
    NSRectFill(NSMakeRect(0, height * 2, fullrect.size.width, height + margin));
  }
}

- (void)setColor:(NSColor*)c0 c1:(NSColor*)c1 c2:(NSColor*)c2 {
  CGFloat opacity = (CGFloat)(self.preferencesModel.indicatorOpacity) / 100.0f;

  // If indicator size is too large, set transparency in order to avoid the indicator hides all windows.
  NSRect fullrect = [self frame];
  CGFloat menuBarHeight = [[NSApp mainMenu] menuBarHeight];
  if (fullrect.size.width > menuBarHeight &&
      fullrect.size.height > menuBarHeight) {
    CGFloat maxOpacity = 0.8;
    if (opacity > maxOpacity) {
      opacity = maxOpacity;
    }
  }

  self.color0 = [c0 colorWithAlphaComponent:(opacity * [c0 alphaComponent])];
  self.color1 = [c1 colorWithAlphaComponent:(opacity * [c1 alphaComponent])];
  self.color2 = [c2 colorWithAlphaComponent:(opacity * [c2 alphaComponent])];
  [self display];
}

@end
