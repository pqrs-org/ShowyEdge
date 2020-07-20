#import "ColorsTableViewDelegate.h"
#import "ColorUtilities.h"
#import "ColorsCellView.h"
#import "PreferencesClient.h"
#import "PreferencesModel.h"

@interface ColorsTableViewDelegate ()

@property(weak) IBOutlet PreferencesClient* preferencesClient;

@end

@implementation ColorsTableViewDelegate

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row {
  NSArray* array = self.preferencesClient.pm.inputSourceColors;

  if (0 <= row && row < (NSInteger)([array count])) {
    NSDictionary* dict = array[row];

    ColorsCellView* result = [tableView makeViewWithIdentifier:@"ColorsCellView" owner:self];
    result.inputSourceID = dict[@"inputsourceid"];
    result.tableView = tableView;
    result.preferencesClient = self.preferencesClient;

    result.textField.stringValue = dict[@"inputsourceid"];
    result.color0.color = [ColorUtilities colorFromString:dict[@"color0"]];
    result.color1.color = [ColorUtilities colorFromString:dict[@"color1"]];
    result.color2.color = [ColorUtilities colorFromString:dict[@"color2"]];
    return result;
  }

  return nil;
}

@end
