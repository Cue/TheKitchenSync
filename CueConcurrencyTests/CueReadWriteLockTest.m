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

#import "CueReadWriteLockTest.h"
#import "CueConcurrency.h"
#import "CueThreadSteps.h"

// a = acquiring
// h = held
// r = releasing

#define A(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

#define STEP(s) [NSString stringWithFormat:@"%@%@", [[NSThread currentThread] name], s]

#define READ_LOCK(num) [_test runOnThread:num block:^{ \
    [_result addObject:STEP(@"a")]; \
    [_lock lockForRead]; \
    [_result addObject:STEP(@"h")]; \
}]

#define WRITE_LOCK(num) [_test runOnThread:num block:^{ \
    [_result addObject:STEP(@"a")]; \
    [_lock lockForRead]; \
    [_result addObject:STEP(@"h")]; \
}]

#define ASYNC_READ_LOCK(num) [_test asyncRunOnThread:num untilLocked:_lock block:^{ \
    [_result addObject:STEP(@"a")]; \
    [_lock lockForRead]; \
    [_result addObject:STEP(@"h")]; \
}]

#define ASYNC_WRITE_LOCK(num) [_test asyncRunOnThread:num untilLocked:_lock block:^{ \
    [_result addObject:STEP(@"a")]; \
    [_lock lockForWrite]; \
    [_result addObject:STEP(@"h")]; \
}]

#define UNLOCK_THREAD(num) [_test runOnThread:num block:^{ \
  [_result addObject:STEP(@"r")]; \
  [_lock unlock]; \
}]

#define UNLOCK(count) for (int __unlock = 1; __unlock <= count; __unlock++ ) { UNLOCK_THREAD(__unlock); }


@implementation CueReadWriteLockTest {
    NSMutableArray *_result;
    CueReadWriteLock *_lock;
    CueThreadSteps *_test;
}

- (void)setUp;
{
    _result = [[NSMutableArray array] retain];
    _lock = [[CueReadWriteLock alloc] init];
    _test = [[CueThreadSteps alloc] init];
}

- (void)tearDown;
{
    [_result release];
    [_lock release];
    [_test release];
}

- (void)testReaders;
{
    READ_LOCK(1);
    READ_LOCK(2);
    UNLOCK(2);

    NSMutableArray *expected = A(@"T1a", @"T1h", @"T2a", @"T2h", @"T1r", @"T2r");
    AssertObjectEquals(expected, _result);
}

- (void)testWriters;
{
    WRITE_LOCK(1);
    ASYNC_WRITE_LOCK(2);
    UNLOCK(2);

    NSMutableArray *expected = A(@"T1a", @"T1h", @"T2a", @"T1r", @"T2h", @"T2r");
    AssertObjectEquals(expected, _result);
}

- (void)testReadersAndWriters;
{
    READ_LOCK(1);
    READ_LOCK(2);
    ASYNC_WRITE_LOCK(3);
    UNLOCK(3);

    NSMutableArray *expected = A(@"T1a", @"T1h", @"T2a", @"T2h", @"T3a", @"T1r", @"T2r", @"T3h", @"T3r");
    AssertObjectEquals(expected, _result);
}

- (void)testNoWriterStarving;
{
    READ_LOCK(1);
    ASYNC_WRITE_LOCK(2);
    // Lock in a different order than unlock to prove that both threads acquire the lock.
    [_test asyncRunOnThread:4 untilLocked:_lock block:^{
        [_result addObject:STEP(@"a")];
        [_lock lockForRead];
    }];
    [_test asyncRunOnThread:3 untilLocked:_lock block:^{
        [_result addObject:STEP(@"a")];
        [_lock lockForRead];
    }];
    ASYNC_WRITE_LOCK(5);
    ASYNC_READ_LOCK(6);
    UNLOCK(6);

    NSMutableArray *expected = A(
        @"T1a", @"T1h", @"T2a", @"T4a", @"T3a", @"T5a", @"T6a", @"T1r", @"T2h", @"T2r",
        @"T3r", @"T4r", @"T5h", @"T5r", @"T6h", @"T6r");
    AssertObjectEquals(expected, _result);
}

@end
