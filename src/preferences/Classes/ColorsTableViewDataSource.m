#import "ColorsTableViewDataSource.h"
#import "PreferencesClient.h"
#import "PreferencesModel.h"

@interface ColorsTableViewDataSource ()

@property(weak) IBOutlet PreferencesClient* preferencesClient;

@end

@implementation ColorsTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
  return [self.preferencesClient.pm.inputSourceColors count];
}

@end
