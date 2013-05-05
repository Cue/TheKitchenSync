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
