//
//  CCThreadedTest
//  Greplin
//
//  Created by Robby Walker on 7/19/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import "CCThreadSteps.h"

@implementation CCThreadSteps

- (id)init;
{
    if ((self = [super init])) {
        _threads = [[NSMutableDictionary dictionary] retain];

    }

    return self;
}

- (void)dealloc;
{
    [_threads release];
    [super dealloc];
}

- (void)runBlock:(void (^)())block;
{
    block();
}

- (void)threadMain;
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

    while (!_isStopped) {
        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    [pool release];
}

- (NSThread *)getThread:(int)threadId;
{
    NSNumber *number = [NSNumber numberWithInt:threadId];
    NSThread *result = [_threads objectForKey:number];
    if (result) {
        return result;
    }
    result = [[[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil] autorelease];
    result.name = [NSString stringWithFormat:@"T%d", threadId];
    [result start];
    [_threads setObject:result forKey:number];
    return result;
}

- (void)runOnThread:(int)threadId block:(void (^)())block;
{
    NSThread *thread = [self getThread:threadId];
    [self performSelector:@selector(runBlock:) onThread:thread withObject:block waitUntilDone:YES];
}

- (void)asyncRunOnThread:(int)threadId block:(void (^)())block;
{
    NSThread *thread = [self getThread:threadId];
    [self performSelector:@selector(runBlock:) onThread:thread withObject:block waitUntilDone:NO];
}

- (void)asyncRunOnThread:(int)threadId untilLocked:(id<CueTestableLock>)lock block:(void (^)())block;
{
    int before = [lock getCounterForTesting];
    NSThread *thread = [self getThread:threadId];
    [self performSelector:@selector(runBlock:) onThread:thread withObject:block waitUntilDone:NO];
    while ([lock getCounterForTesting] != before + 1) {
        // spin lock
    }
}

@end
