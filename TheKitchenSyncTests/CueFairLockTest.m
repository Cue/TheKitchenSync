/*
 * Copyright 2013 TheKitchenSync Authors.
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

#import "CueFairLockTest.h"
#import "TheKitchenSync.h"
#import "CueThreadSteps.h"


#define NAME [[NSThread currentThread] name]

@implementation CueFairLockTest

- (void)testFairness;
{
    NSMutableArray *result = [NSMutableArray array];
    CueFairLock *lock = [[CueFairLock alloc] init];
    CueThreadSteps *test = [[CueThreadSteps alloc] init];

    [test runOnThread:1 block:^{
        [result addObject:NAME];
        [lock lock];
        [result addObject:NAME];
    }];
    [test asyncRunOnThread:2 untilLocked:lock block:^{
        [result addObject:NAME];
        [lock lock];
        [result addObject:NAME];
    }];
    [test asyncRunOnThread:3 untilLocked:lock block:^{
        [result addObject:NAME];
        [lock lock];
        [result addObject:NAME];
    }];
    [test runOnThread:1 block:^{
        [lock unlock];
    }];
    [test runOnThread:2 block:^{
        [lock unlock];
    }];
    [test runOnThread:3 block:^{
        [lock unlock];
    }];

    [lock release];
    [test release];

    NSMutableArray *expected = [NSMutableArray arrayWithObjects:@"T1", @"T1", @"T2", @"T3", @"T2", @"T3", nil];
    AssertObjectEquals(expected, result);
}


@end
