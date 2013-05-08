/*
 * Copyright 2013 The CueConcurrency Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CueThreadSteps.h"

@implementation CueThreadSteps

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
