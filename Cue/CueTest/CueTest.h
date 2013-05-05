//
//  CueTest.h
//  CueTest
//
//  Created by Robby Walker on 7/11/12.
//  Copyright (c) 2012 Cue. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define AssertObjectEquals(expected, actual) STAssertEqualObjects(expected, actual, @"should be equal")
#define AssertCount(expected, collection, message) STAssertEquals((NSUInteger) expected, [collection count], message)

/**
 * These two macros require UIImage+CueUI.h
 */
#define AssertImageEquals(expected, actual, message) STAssertTrue([expected cuIsEqual:actual], message)
#define AssertImageNotEquals(expected, actual, message) STAssertFalse([expected cuIsEqual:actual], message)

#define TEST_CLASS(name) @interface name : CueTest \
@end

#define CC_CONNECTION_TYPES_PRIVILEGED

/**
 * Cue-specific test cases.
 */
@interface CueTest : SenTestCase

@end
