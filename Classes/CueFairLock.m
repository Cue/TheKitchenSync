//
//  CueFairLock
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.

#import "CueFairLock.h"
#import <libkern/OSAtomic.h>

@implementation CueFairLock {
    NSConditionLock *_lock;
    int32_t _counter;
}

- (id)init;
{
    self = [super init];
    if (self) {
        _lock = [[NSConditionLock alloc] initWithCondition:1];
        _counter = 0;
    }

    return self;
}

- (void)dealloc;
{
    [_lock release];
    [super dealloc];
}

- (void)lock;
{
    int order = OSAtomicIncrement32(&_counter);
    [_lock lockWhenCondition:order];
}

- (void)unlock;
{
    [_lock unlockWithCondition:([_lock condition] + 1)];
}

- (int32_t)getCounterForTesting;
{
    return _counter;
}

@end
