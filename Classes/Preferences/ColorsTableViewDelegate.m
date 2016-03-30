#import "ColorsCellView.h"
#import "ColorsTableViewDelegate.h"
#import "PreferencesKeys.h"
#import "PreferencesWindowController.h"

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
    return result;
  }

  return nil;
}

@end
