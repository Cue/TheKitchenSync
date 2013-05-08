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

#import "CueThreadLocalTest.h"
#import "CueConcurrency.h"
#import "CueThreadSteps.h"

@implementation CueThreadLocalTest

- (void)testThreadLocal;
{
    NSMutableArray *result = [NSMutableArray array];
    CueThreadLocal *a = [[[CueThreadLocal alloc] init] autorelease];
    CueThreadLocal *b = [[[CueThreadLocal alloc] init] autorelease];
    CueThreadSteps *test = [[[CueThreadSteps alloc] init] autorelease];

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
