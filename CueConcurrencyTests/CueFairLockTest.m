//
//  CCFairLockTest
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import "CueFairLockTest.h"
#import "CueFairLock.h"
#import "CCThreadSteps.h"


#define NAME [[NSThread currentThread] name]

@implementation CueFairLockTest

- (void)testFairness;
{
    NSMutableArray *result = [NSMutableArray array];
    CueFairLock *lock = [[CueFairLock alloc] init];
    CCThreadSteps *test = [[CCThreadSteps alloc] init];

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
