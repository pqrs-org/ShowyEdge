/* -*- mode: objective-c -*- */

@import Cocoa;

@interface WorkSpaceData : NSObject

@property(copy, readonly) NSString* currentInputSourceID;
@property(copy, readonly) NSString* currentInputModeID;
@property(copy, readonly) NSSet* menubarOrigins;

- (void)setup;

@end
