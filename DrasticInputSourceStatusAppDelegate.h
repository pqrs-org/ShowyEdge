/* -*- Mode: objc; Coding: utf-8; indent-tabs-mode: nil; -*- */
//
//  DrasticInputSourceStatusAppDelegate.h
//  DrasticInputSourceStatus
//
//  Created by Takayama Fumihiko on 10/08/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DrasticInputSourceStatusAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow* window;
}

@property (assign) IBOutlet NSWindow* window;

@end
