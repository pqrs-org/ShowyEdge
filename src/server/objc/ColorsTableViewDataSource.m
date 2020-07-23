#import "ColorsTableViewDataSource.h"
#import "PreferencesManager.h"

@implementation ColorsTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
  return PreferencesManager.customizedLanguageColors.count;
}

@end
