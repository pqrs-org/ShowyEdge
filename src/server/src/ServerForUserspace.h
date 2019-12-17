// -*- mode: objective-c -*-

@import Cocoa;
#import "ServerClientProtocol.h"

@interface ServerForUserspace : NSObject <ServerClientProtocol>

- (BOOL)registerService;

@end
