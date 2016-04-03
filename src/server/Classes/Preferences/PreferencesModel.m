#import "NotificationKeys.h"
#import "PreferencesKeys.h"
#import "PreferencesModel.h"

@implementation PreferencesModel

- (instancetype)init {
  self = [super init];

  if (self) {
    self.customFrameTop = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomFrameTop];
  }

  return self;
}

- (IBAction)updateCustomFrame:(id)sender {
  [[NSUserDefaults standardUserDefaults] setObject:@(self.customFrameTop) forKey:kCustomFrameTop];
  [[NSNotificationCenter defaultCenter] postNotificationName:kIndicatorConfigurationChangedNotification object:nil];
}

@end
