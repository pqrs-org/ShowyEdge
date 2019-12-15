@import Carbon;
#import "WorkSpaceData.h"
#import "NotificationKeys.h"
#import "SharedKeys.h"
#import "weakify.h"

@interface WorkSpaceData ()

@property(copy, readwrite) NSString* currentInputSourceID;
@property(copy, readwrite) NSString* currentInputModeID;
@property(readwrite) BOOL isFullScreenSpace;

@end

@implementation WorkSpaceData

- (void)observer_kTISNotifySelectedKeyboardInputSourceChanged:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
    if (!ref) goto finish;

    self.currentInputSourceID = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputSourceID));
    self.currentInputModeID = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputModeID));

    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentInputSourceIDChangedNotification object:nil];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kShowyEdgeCurrentInputSourceIDChangedNotification
                                                                   object:nil
                                                                 userInfo:nil
                                                       deliverImmediately:YES];

  finish:
    if (ref) {
      CFRelease(ref);
    }
  });
}

- (instancetype)init {
  self = [super init];

  if (self) {
    self.currentInputSourceID = @"";
    self.currentInputModeID = @"";
    self.isFullScreenSpace = NO;

    // In Mac OS X 10.7, NSDistributedNotificationCenter is suspended after calling [NSAlert runModal].
    // So, we need to set suspendedDeliveryBehavior to NSNotificationSuspensionBehaviorDeliverImmediately.
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                            name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                            object:nil
                                              suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];

    @weakify(self);
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceActiveSpaceDidChangeNotification
                                                                    object:nil
                                                                     queue:[NSOperationQueue mainQueue]
                                                                usingBlock:^(NSNotification* note) {
                                                                  @strongify(self);
                                                                  if (!self) return;

                                                                  [self updateIsFullScreenSpace];
                                                                }];
  }

  return self;
}

- (void)setup {
  [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];
  [self updateIsFullScreenSpace];
}

- (void)dealloc {
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateIsFullScreenSpace {
  BOOL previousValue = self.isFullScreenSpace;

  NSArray* windows = CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID));

  // We detect full screen spaces by checking if there's a menubar in the window list.
  // If not, we assume it's in fullscreen mode.
  for (NSDictionary* d in windows) {
    if ([d[@"kCGWindowOwnerName"] isEqualToString:@"Window Server"] &&
        [d[@"kCGWindowName"] isEqualToString:@"Menubar"]) {
      self.isFullScreenSpace = NO;
      goto finish;
    }
  }

  self.isFullScreenSpace = YES;

finish:
  if (self.isFullScreenSpace != previousValue) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreenModeChangedNotification object:nil];
  }
}

@end
