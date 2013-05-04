//
//  CCThreadLocalTest
//  Greplin
//
//  Created by Robby Walker on 7/19/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//
#import "CueThreadLocalTest.h"
#import "CueThreadLocal.h"
#import "CCThreadSteps.h"

@implementation CueThreadLocalTest

- (void)testThreadLocal;
{
    NSMutableArray *result = [NSMutableArray array];
    CueThreadLocal *a = [[[CueThreadLocal alloc] init] autorelease];
    CueThreadLocal *b = [[[CueThreadLocal alloc] init] autorelease];
    CCThreadSteps *test = [[[CCThreadSteps alloc] init] autorelease];

    [test runOnThread:1 block:^{
        [result addObject:[a get] ? @"1t" : @"1f"];
        [a set:@"1a"];
        [b set:@"1b"];
    }];
    [test runOnThread:2 block:^{
        [result addObject:[a get] ? @"2t" : @"2f"];
        [a set:@"2a"];
        [b set:@"2b"];
    }];
    [test runOnThread:1 block:^{
        [result addObject:[a get]];
        [result addObject:[b get]];
    }];
    [test runOnThread:2 block:^{
        [result addObject:[a get]];
        [result addObject:[b get]];
    }];


    NSMutableArray *expected = [NSMutableArray arrayWithObjects:@"1f", @"2f", @"1a", @"1b", @"2a", @"2b", nil];
    AssertObjectEquals(expected, result);
}

@end
