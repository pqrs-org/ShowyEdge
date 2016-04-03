#import "ColorsCellView.h"
#import "ColorsTableViewDelegate.h"
#import "PreferencesKeys.h"
#import "PreferencesManager.h"
#import "PreferencesWindowController.h"
#import "ServerObjects.h"

@interface ColorsTableViewDelegate ()

@property(weak) IBOutlet PreferencesWindowController* preferencesWindowController;

@end

@implementation ColorsTableViewDelegate

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row {
  NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor];

  if (0 <= row && row < (NSInteger)([array count])) {
    NSDictionary* dict = array[row];

    ColorsCellView* result = [tableView makeViewWithIdentifier:@"ColorsCellView" owner:self];
    result.inputSourceID = dict[@"inputsourceid"];
    result.tableView = tableView;
    result.serverObjects = self.preferencesWindowController.serverObjects;

    result.textField.stringValue = dict[@"inputsourceid"];
    result.color0.color = [self.preferencesWindowController.serverObjects.preferencesManager colorFromString:dict[@"color0"]];
    result.color1.color = [self.preferencesWindowController.serverObjects.preferencesManager colorFromString:dict[@"color1"]];
    result.color2.color = [self.preferencesWindowController.serverObjects.preferencesManager colorFromString:dict[@"color2"]];
    return result;
  }

  return nil;
}

@end
