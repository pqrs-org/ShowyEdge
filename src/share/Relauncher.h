// -*- mode: objective-c -*-

@import Cocoa;

@interface Relauncher : NSObject

+ (NSInteger)getRelaunchedCount;
+ (void)resetRelaunchedCount;
+ (void)relaunch;
+ (BOOL)isEqualPreviousProcessVersionAndCurrentProcessVersion;

@end
