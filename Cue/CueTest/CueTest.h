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
