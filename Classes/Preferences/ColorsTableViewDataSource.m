#import "ColorsTableViewDataSource.h"
#import "PreferencesKeys.h"

@implementation ColorsTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
  return [[[NSUserDefaults standardUserDefaults] arrayForKey:kCustomizedLanguageColor] count];
}

@end
