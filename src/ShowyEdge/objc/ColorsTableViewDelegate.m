#import "ColorsTableViewDelegate.h"
#import "ColorUtilities.h"
#import "ColorsCellView.h"
#import "PreferencesManager.h"

@interface ColorsTableViewDelegate ()
@end

@implementation ColorsTableViewDelegate

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row {
  NSArray* colors = PreferencesManager.customizedLanguageColors;

  if (0 <= row && row < (NSInteger)(colors.count)) {
    NSDictionary* dict = colors[row];

    ColorsCellView* result = [tableView makeViewWithIdentifier:@"ColorsCellView" owner:self];
    result.inputSourceID = dict[@"inputsourceid"];
    result.tableView = tableView;

    result.textField.stringValue = dict[@"inputsourceid"];
    result.color0.color = [ColorUtilities colorFromString:dict[@"color0"]];
    result.color1.color = [ColorUtilities colorFromString:dict[@"color1"]];
    result.color2.color = [ColorUtilities colorFromString:dict[@"color2"]];
    return result;
  }

  return nil;
}

@end
