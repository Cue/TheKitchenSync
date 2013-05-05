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
