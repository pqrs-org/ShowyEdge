@import Carbon;
#import "NotificationKeys.h"
#import "WorkSpaceData.h"

@interface WorkSpaceData ()

@property(copy, readwrite) NSString* currentInputSourceID;
@property(copy, readwrite) NSString* currentInputModeID;

@end

@implementation WorkSpaceData

- (void)observer_kTISNotifySelectedKeyboardInputSourceChanged:(NSNotification*)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
    if (!ref) goto finish;

    self.currentInputSourceID = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputSourceID));
    self.currentInputModeID = (__bridge NSString*)(TISGetInputSourceProperty(ref, kTISPropertyInputModeID));

    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentInputSourceIDChangedNotification object:nil];

  finish:
    if (ref) {
      CFRelease(ref);
    }
  });
}

- (instancetype)init {
  self = [super init];

  if (self) {
    // In Mac OS X 10.7, NSDistributedNotificationCenter is suspended after calling [NSAlert runModal].
    // So, we need to set suspendedDeliveryBehavior to NSNotificationSuspensionBehaviorDeliverImmediately.
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(observer_kTISNotifySelectedKeyboardInputSourceChanged:)
                                                            name:(NSString*)(kTISNotifySelectedKeyboardInputSourceChanged)
                                                          object:nil
                                              suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];

    [self observer_kTISNotifySelectedKeyboardInputSourceChanged:nil];
  }

  return self;
}

- (void)dealloc {
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

@end
