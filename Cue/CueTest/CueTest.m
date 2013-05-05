//
//  CueTest.m
//  CueTest
//
//  Created by Robby Walker on 8/22/12.
//  Copyright (c) 2012 Cue. All rights reserved.
//

// NOTE: This file must be included manually in every test target.
// TODO(robbyw): Split out testing libraries in to their own sub-target.

#import "CueTest.h"

@implementation CueTest

+ (id)defaultTestSuite;
{
    if (self == [CueTest class]) {
        return nil;
    } else {
        return [super defaultTestSuite];
    }
}

- (void)setUpTestWithSelector:(SEL)testMethod;
{
    NSLog(@"----- %@.%@ -----", [self class], NSStringFromSelector(testMethod));
    [super setUpTestWithSelector:testMethod];
}

@end
