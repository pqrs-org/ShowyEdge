#import "DeprecatedOpenAtLoginObjc.h"

// Note:
// There is a bug in the swift binding of kLSSharedFileListItemLast that causes EXC_BAD_ACCESS on macOS 12 and above with the following code
//
// `kLSSharedFileListItemLast.takeUnretainedValue()`
//
// Therefore, we have to implement in Objective-C.

@implementation DeprecatedOpenAtLoginObjc

+ (LSSharedFileListItemRef)copyLSSharedFileListItemRef:(LSSharedFileListRef)loginItems appURL:(NSURL*)appURL {
  if (!loginItems) return NULL;

  LSSharedFileListItemRef retval = NULL;

  UInt32 seed = 0U;
  CFArrayRef currentLoginItemsRef = LSSharedFileListCopySnapshot(loginItems, &seed);
  NSArray* currentLoginItems = CFBridgingRelease(currentLoginItemsRef);
  for (id itemObject in currentLoginItems) {
    LSSharedFileListItemRef item = (__bridge LSSharedFileListItemRef)itemObject;

    UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
    CFURLRef urlRef = NULL;
    OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &urlRef, NULL);
    if (err == noErr) {
      NSURL* url = CFBridgingRelease(urlRef);
      BOOL foundIt = [url isEqual:appURL];

      if (foundIt) {
        retval = item;
        break;
      }
    }
  }

  if (retval) {
    CFRetain(retval);
  }

  return retval;
}

+ (LSSharedFileListRef)createLoginItems {
  return LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
}

+ (BOOL)registered:(NSURL*)appURL {
  BOOL result = NO;

  LSSharedFileListRef loginItems = [self createLoginItems];
  if (loginItems) {
    LSSharedFileListItemRef item = [self copyLSSharedFileListItemRef:loginItems appURL:appURL];
    if (item) {
      result = YES;

      CFRelease(item);
    }

    CFRelease(loginItems);
  }

  return result;
}

+ (void)register:(NSURL*)appURL {
  if ([self registered:appURL]) {
    return;
  }

  LSSharedFileListRef loginItems = [self createLoginItems];
  if (loginItems) {
    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)(appURL), NULL, NULL);
    if (item) {
      CFRelease(item);
    }

    CFRelease(loginItems);
  }
}

+ (void)unregister:(NSURL*)appURL {
  LSSharedFileListRef loginItems = [self createLoginItems];
  if (loginItems) {
    LSSharedFileListItemRef item = [self copyLSSharedFileListItemRef:loginItems appURL:appURL];
    if (item) {
      LSSharedFileListItemRemove(loginItems, item);

      CFRelease(item);
    }

    CFRelease(loginItems);
  }
}

@end
