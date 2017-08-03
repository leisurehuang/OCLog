//
//  UIBlockCheckThread.m
//  OCLog
//
//  Created by Lei Huang on 11/01/2017.
//  Copyright © 2017  Lei Huang. All rights reserved.
//

#import "UIBlockCheckThread.h"

@interface UIBlockCheckThread ()
@property(nonatomic, assign) BOOL pingTaskIsRunning;
@property(nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation UIBlockCheckThread


- (instancetype)init {
    if (self = [super init]) {
        self.pingTaskIsRunning = NO;
        self.semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)main {
    while (!self.cancelled) {
        self.pingTaskIsRunning = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pingTaskIsRunning = NO;
            dispatch_semaphore_signal(self.semaphore);
        });
        [NSThread sleepForTimeInterval:0.4];
        if (self.pingTaskIsRunning) {
            // warning here
            NSLog(@"UI block warning here!!!!");
       }
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }
}

@end
