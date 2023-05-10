// -*- mode: objective-c -*-

@import AppKit;

@interface DeprecatedOpenAtLoginObjc : NSObject

+ (BOOL)registered:(NSURL *)appURL
    API_DEPRECATED("Use SMAppService", macos(10.5, 12.0));

+ (void)register:(NSURL *)appURL
    API_DEPRECATED("Use SMAppService", macos(10.5, 12.0));

+ (void)unregister:(NSURL *)appURL
    API_DEPRECATED("Use SMAppService", macos(10.5, 12.0));

@end
