#import "ColorsCellView.h"
#import "ServerObjects.h"
#import "PreferencesManager.h"

@implementation ColorsCellView

- (IBAction)removeInputSourceID:(id)sender {
  [self.serverObjects.preferencesManager removeInputSourceID:self.inputSourceID];
  [self.tableView reloadData];
}

@end
