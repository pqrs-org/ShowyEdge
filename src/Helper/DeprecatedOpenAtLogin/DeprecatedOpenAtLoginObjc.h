// -*- mode: objective-c -*-

@import AppKit;

@interface DeprecatedOpenAtLoginObjc : NSObject

+ (BOOL)registered:(NSURL *)appURL;

+ (void)register:(NSURL *)appURL;
+ (void)unregister:(NSURL *)appURL;

@end
