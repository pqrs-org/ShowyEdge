#import "ColorsTableViewDataSource.h"
#import "PreferencesModel.h"

@interface ColorsTableViewDataSource ()

@property(weak) IBOutlet PreferencesModel* preferencesModel;

@end

@implementation ColorsTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
  return [self.preferencesModel.inputSourceColors count];
}

@end
