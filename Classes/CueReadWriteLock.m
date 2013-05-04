//
//  CueReadWriteLock
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import "CueReadWriteLock.h"

@implementation CueReadWriteLock {
    CueFairLock *_fairLock;
    volatile NSLock *_primaryReader;
    NSMutableSet *_activeReaders;
    CueThreadLocal *_readLocks;
}

- (id)init;
{
    if ((self = [super init])) {
        _fairLock = [[CueFairLock alloc] init];

        _primaryReader = nil;
        _activeReaders = [[NSMutableSet set] retain];
        _readLocks = [[CueThreadLocal alloc] init];
    }
    return self;
}

- (void)dealloc;
{
    [_fairLock release];
    [_activeReaders release];
    [_primaryReader release]; // Gets rid of an AppCode warning, though this should always be nil in practice.
    [_readLocks release];
    [super dealloc];
}

- (void)lockForWrite;
{
    [_fairLock lock];
    while (_primaryReader) {
        volatile NSLock *reader = [_primaryReader retain];
        [reader lock];
        [reader unlock];
        [reader release];
    }
}

- (void)unlockForWrite;
{
    [_fairLock unlock];
}

- (void)lockForRead;
{
    [_fairLock lock];
    NSLock *thisLock = [[[NSLock alloc] init] autorelease];
    if (_primaryReader) {
        @synchronized (_activeReaders) {
            [_activeReaders addObject:thisLock];
        }
    } else {
        _primaryReader = [thisLock retain];
    }
    [thisLock lock];
    [_readLocks set:thisLock];
    [_fairLock unlock];
}

- (void)unlockForRead;
{
    NSLock *thisLock = [[[_readLocks get] retain] autorelease];
    @synchronized (_activeReaders) {
        if (thisLock == _primaryReader) {
            [_primaryReader release];
            _primaryReader = [[_activeReaders anyObject] retain];
            if (_primaryReader) {
                [_activeReaders removeObject:_primaryReader];
            }
        } else {
            [_activeReaders removeObject:thisLock];
        }
    }
    [_readLocks remove];

    [thisLock unlock];
}

- (void)lock;
{
    [self lockForRead];
}

- (void)unlock;
{
    if ([_readLocks get]) {
        [self unlockForRead];
    } else {
        [self unlockForWrite];
    }
}

- (int32_t)getCounterForTesting;
{
    return [_fairLock getCounterForTesting];
}

@end
