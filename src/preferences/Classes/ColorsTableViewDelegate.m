#import "ColorsTableViewDelegate.h"
#import "ColorUtilities.h"
#import "ColorsCellView.h"
#import "PreferencesModel.h"
#import "PreferencesWindowController.h"
#import "ServerClient.h"

@interface ColorsTableViewDelegate ()

@property(weak) IBOutlet PreferencesModel* preferencesModel;
@property(weak) IBOutlet PreferencesWindowController* preferencesWindowController;
@property(weak) IBOutlet ServerClient* client;

@end

@implementation ColorsTableViewDelegate

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row {
  NSArray* array = self.preferencesModel.inputSourceColors;

  if (0 <= row && row < (NSInteger)([array count])) {
    NSDictionary* dict = array[row];

    ColorsCellView* result = [tableView makeViewWithIdentifier:@"ColorsCellView" owner:self];
    result.inputSourceID = dict[@"inputsourceid"];
    result.tableView = tableView;
    result.preferencesModel = self.preferencesModel;
    result.client = self.client;

    result.textField.stringValue = dict[@"inputsourceid"];
    result.color0.color = [ColorUtilities colorFromString:dict[@"color0"]];
    result.color1.color = [ColorUtilities colorFromString:dict[@"color1"]];
    result.color2.color = [ColorUtilities colorFromString:dict[@"color2"]];
    return result;
  }

  return nil;
}

@end
