#import "ColorsCellView.h"
#import "PreferencesManager.h"

@implementation ColorsCellView

- (IBAction)removeInputSourceID:(id)sender {
  [PreferencesManager removeCustomizedLanguageColor:self.inputSourceID];

  [self.tableView reloadData];
}

- (NSString*)hexString:(CGFloat)component {
  int v = (int)(component * 0xff);
  if (v < 0) {
    v = 0;
  } else if (v > 0xff) {
    v = 0xff;
  }
  return [NSString stringWithFormat:@"%02x", v];
}

- (void)colorChanged:(NSString*)key color:(NSColor*)color {
  NSString* value = [NSString stringWithFormat:@"#%@%@%@%@",
                                               [self hexString:[color redComponent]],
                                               [self hexString:[color greenComponent]],
                                               [self hexString:[color blueComponent]],
                                               [self hexString:[color alphaComponent]]];

  [PreferencesManager changeCustomizedLanguageColor:self.inputSourceID key:key color:value];
}

- (IBAction)color0Changed:(id)sender {
  [self colorChanged:@"color0" color:self.color0.color];
}

- (IBAction)color1Changed:(id)sender {
  [self colorChanged:@"color1" color:self.color1.color];
}

- (IBAction)color2Changed:(id)sender {
  [self colorChanged:@"color2" color:self.color2.color];
}

@end
